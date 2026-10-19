defmodule BexioApiClient.Req.AccessTokenRefresher do
  require Logger

  @expires_in_reserve 60
  @access_tokens_table :bexio_api_client_access_tokens
  @refresh_failures_table :bexio_api_client_refresh_failures
  @refresh_locks_table :bexio_api_client_refresh_locks

  @base_backoff_ms 500
  @backoff_cap_ms 30_000
  @rate_limit_base_ms 1_000
  @rate_limit_cap_ms 60_000
  @transient_failures_before_cooldown 5
  @cooldown_ms 5 * 60 * 1000
  @lock_ttl_ms 30_000
  @wait_step_ms 100
  @max_wait_ms 5_000

  @moduledoc """
  Req request step that fetches and caches access tokens for Bexio OAuth2
  clients.

  The access token cache lives in the ETS table `:bexio_api_client_access_tokens`
  and is keyed by `{client_id, refresh_token}`. Each entry stores
  `{access_token, expires_at}` with an expiry reserve of #{@expires_in_reserve}
  seconds.

  Bexio does not currently rotate refresh tokens (the same refresh token keeps
  working), so the refresher does not manage rotation: it always refreshes with
  the refresh token the host application passed to `BexioApiClient.new/3`. Should
  Bexio ever enable rotation (a Keycloak realm option), token responses would
  expose the new token through `BexioApiClient.access_token/3` and host
  applications would have to persist it themselves.

  Refresh failures are classified and stored with a backoff deadline in
  `:bexio_api_client_refresh_failures`:

    * `400`/`401` `invalid_grant` responses and `403` responses (Bexio blocks
      misbehaving OAuth clients, e.g. after a retry flood on failing refreshes)
      are permanent: requests fail fast without touching the token endpoint
      again. Call `clear_refresh_failure/1` once the host supplies a new refresh
      token.
    * `429` backs off exponentially (1s, 2s, 4s ... capped at 60s).
    * transport errors and other statuses back off exponentially with jitter
      (base 500ms, cap 30s); after #{@transient_failures_before_cooldown}
      consecutive failures requests fail fast for 5 minutes.

  While a refresh is in flight, concurrent requests on the same entry wait for
  the result instead of refreshing in parallel (single flight).

  On any refresh failure the request pipeline halts with
  `BexioApiClient.RefreshError`; requests are never sent unauthenticated. Retry
  policy for the token endpoint belongs to this module, so host applications
  should not wrap requests in their own retry loops.

  ## Giving up and the `:on_refresh_gave_up` callback

  The refresher gives up on a refresh token in two cases:

    * a permanent failure (`:invalid_refresh_token`, `:client_blacklisted`) is
      recorded — giving up on the first occurrence,
    * #{@transient_failures_before_cooldown} consecutive transient failures
      enter the 5-minute cooldown.

  At that transition the optional `:on_refresh_gave_up` callback is invoked
  **once** (not on subsequent backoff-rejected requests):

      BexioApiClient.new(client_id, client_secret, refresh_token,
        on_refresh_gave_up: {MyApp.Auth, :refresh_gave_up, [user_id]}
      )

  called as `apply(module, function, args ++ [client_id, error_class])`. Host
  applications can react by re-authenticating the user, disabling sync jobs or
  alerting, and re-enable the token afterwards with `clear_refresh_failure/1`.
  The callback runs synchronously in the failing request's process while the
  refresh lock is held: keep it fast and do not make requests with the same
  client from it.

  ## ETS table ownership

  The tables are owned by the process that created them: when that process
  exits, the tables are deleted together with it. Losing the tables is always
  safe (tokens are a cache and backoff state resets), but the cache silently
  stops working until the tables are recreated.

  Call `create_ets_table/0` once from a long-lived process at application
  startup, e.g. in your application's `start/2`:

      BexioApiClient.Req.AccessTokenRefresher.create_ets_table()

  Then the tables live as long as your application. When they are created
  lazily by request processes instead, any of those processes may end up owning
  the tables, and the cache disappears whenever that process exits. Concurrent
  creation is safe: the losing process ignores the already-exists error.

  ## Telemetry events

    * `[:bexio_api_client, :refresh, :failed]` - a refresh attempt failed.
      Measurements: `%{count: 1}`. Metadata:
      `%{error_class: class, failure_count: count}`
    * `[:bexio_api_client, :refresh, :backoff]` - a request was rejected while a
      backoff was active. Measurements: `%{count: 1}`. Metadata:
      `%{error_class: class, retry_in_ms: milliseconds | :infinity}`
  """

  @spec attach(Req.Request.t(), keyword()) :: Req.Request.t()
  def attach(%Req.Request{} = request, options \\ []) do
    request
    |> Req.Request.register_options([
      :refresh_token,
      :client_id,
      :client_secret,
      :on_refresh_gave_up
    ])
    |> Req.Request.merge_options(options)
    |> Req.Request.prepend_request_steps(get_access_token: &get_access_token/1)
  end

  @doc """
  Creates all ETS tables used by the refresher: the access token cache, the
  refresh failure cache and the refresh locks.
  """
  @spec create_ets_table() :: :ok
  def create_ets_table do
    create_tables()
  end

  defp create_tables do
    Enum.each(
      [@access_tokens_table, @refresh_failures_table, @refresh_locks_table],
      &ensure_table/1
    )
  end

  defp ensure_table(name) do
    case :ets.whereis(name) do
      :undefined ->
        create_table(name)

      _table ->
        :ok
    end
  end

  defp create_table(name) do
    _table = :ets.new(name, [:named_table, :set, :public])
    :ok
  rescue
    ArgumentError -> :ok
  end

  @doc """
  Removes all refresh failures recorded for the given `client_id`, re-enabling
  refresh attempts after a permanent failure (e.g. after the host persisted a
  new refresh token).
  """
  @spec clear_refresh_failure(String.t()) :: :ok
  def clear_refresh_failure(client_id) do
    create_tables()
    :ets.match_delete(@refresh_failures_table, {{client_id, :_}, :_})
    :ok
  end

  @doc """
  Remove all expired access tokens from the ETS table. Triggering this is part of the job of the caller process for now.
  """
  @spec remove_expired_tokens() :: :ok
  def remove_expired_tokens do
    if :ets.whereis(@access_tokens_table) != :undefined do
      @access_tokens_table
      |> :ets.match({:"$0", {:_, :"$1"}})
      |> expired_keys()
      |> Enum.each(&:ets.delete(@access_tokens_table, &1))
    end

    :ok
  end

  defp expired_keys(entries) do
    now = System.system_time(:second)

    for [key, expires_at] <- entries, expires_at <= now do
      key
    end
  end

  defp get_access_token(%Req.Request{} = request) do
    create_tables()

    client_id = Req.Request.get_option(request, :client_id)
    refresh_token = Req.Request.get_option(request, :refresh_token)

    case lookup_entry(client_id, refresh_token) do
      {:fresh, access_token} ->
        use_access_token(request, access_token)

      :stale_or_miss ->
        refresh(request, client_id, refresh_token)
    end
  end

  defp lookup_entry(client_id, refresh_token) do
    now = System.system_time(:second)

    case :ets.lookup(@access_tokens_table, {client_id, refresh_token}) do
      [{_key, {access_token, expires_at}}] when expires_at > now ->
        {:fresh, access_token}

      _ ->
        :stale_or_miss
    end
  end

  defp use_access_token(request, access_token) do
    Req.Request.merge_options(request, auth: {:bearer, access_token})
  end

  defp refresh(request, client_id, refresh_token) do
    if backoff_active?(client_id, refresh_token) do
      fail_fast(request, client_id, refresh_token)
    else
      locked_refresh(request, client_id, refresh_token)
    end
  end

  defp backoff_active?(client_id, refresh_token) do
    case failure_state(client_id, refresh_token) do
      {_error_class, _failure_count, next_retry_at} -> backoff_active?(next_retry_at)
      nil -> false
    end
  end

  defp backoff_active?(:infinity), do: true
  defp backoff_active?(next_retry_at), do: next_retry_at > System.system_time(:millisecond)

  defp fail_fast(request, client_id, refresh_token) do
    {error_class, _failure_count, next_retry_at} = failure_state(client_id, refresh_token)
    retry_in_ms = remaining_backoff(next_retry_at)

    :telemetry.execute(
      [:bexio_api_client, :refresh, :backoff],
      %{count: 1},
      %{error_class: error_class, retry_in_ms: retry_in_ms}
    )

    Req.Request.halt(request, %BexioApiClient.RefreshError{
      reason: {:refresh_backoff, error_class, retry_in_ms}
    })
  end

  defp remaining_backoff(:infinity), do: :infinity

  defp remaining_backoff(next_retry_at),
    do: max(next_retry_at - System.system_time(:millisecond), 0)

  defp locked_refresh(request, client_id, refresh_token) do
    if acquire_lock(client_id, refresh_token) do
      try do
        fetch_and_apply(request, client_id, refresh_token)
      after
        release_lock(client_id, refresh_token)
      end
    else
      wait_or_refresh(request, client_id, refresh_token)
    end
  end

  defp acquire_lock(client_id, refresh_token) do
    key = {client_id, refresh_token}
    now = System.system_time(:millisecond)

    if :ets.insert_new(@refresh_locks_table, {key, now}) do
      true
    else
      take_stale_lock(key, now)
    end
  end

  defp take_stale_lock(key, now) do
    [{_, acquired_at}] = :ets.lookup(@refresh_locks_table, key)

    if now - acquired_at > @lock_ttl_ms do
      :ets.insert(@refresh_locks_table, {key, now})
      true
    else
      false
    end
  end

  defp release_lock(client_id, refresh_token) do
    :ets.delete(@refresh_locks_table, {client_id, refresh_token})
  end

  defp wait_or_refresh(request, client_id, refresh_token) do
    case wait_for_fresh_entry(client_id, refresh_token) do
      {:fresh, access_token} ->
        use_access_token(request, access_token)

      :timeout ->
        locked_refresh(request, client_id, refresh_token)
    end
  end

  defp wait_for_fresh_entry(client_id, refresh_token) do
    deadline = System.system_time(:millisecond) + @max_wait_ms
    do_wait_for_fresh_entry(client_id, refresh_token, deadline)
  end

  defp do_wait_for_fresh_entry(client_id, refresh_token, deadline) do
    case lookup_entry(client_id, refresh_token) do
      {:fresh, access_token} ->
        {:fresh, access_token}

      :stale_or_miss ->
        if System.system_time(:millisecond) >= deadline do
          :timeout
        else
          Process.sleep(@wait_step_ms)
          do_wait_for_fresh_entry(client_id, refresh_token, deadline)
        end
    end
  end

  defp fetch_and_apply(request, client_id, refresh_token) do
    client_secret = Req.Request.get_option(request, :client_secret)

    case BexioApiClient.access_token(refresh_token, client_id, client_secret) do
      {:ok, token} ->
        apply_success(request, client_id, refresh_token, token)

      {:error, reason} ->
        apply_failure(request, client_id, refresh_token, reason)
    end
  end

  defp apply_success(request, client_id, refresh_token, token) do
    expires_at = System.system_time(:second) + token.expires_in - @expires_in_reserve

    :ets.insert(
      @access_tokens_table,
      {{client_id, refresh_token}, {token.access_token, expires_at}}
    )

    use_access_token(request, token.access_token)
  end

  defp apply_failure(request, client_id, refresh_token, reason) do
    error_class = classify(reason)
    failure_count = record_failure(client_id, refresh_token, error_class)

    :telemetry.execute(
      [:bexio_api_client, :refresh, :failed],
      %{count: 1},
      %{error_class: error_class, failure_count: failure_count}
    )

    Logger.error("Access token refresh failed (#{error_class}): #{inspect(reason)}")

    if gave_up?(error_class, failure_count) do
      request
      |> Req.Request.get_option(:on_refresh_gave_up)
      |> call_gave_up_hook(client_id, error_class)
    end

    Req.Request.halt(request, %BexioApiClient.RefreshError{reason: {error_class, reason}})
  end

  defp gave_up?(:rate_limited, _failure_count), do: false

  defp gave_up?(:transient, failure_count),
    do: failure_count == @transient_failures_before_cooldown

  defp gave_up?(_permanent_class, 1), do: true
  defp gave_up?(_permanent_class, _failure_count), do: false

  defp call_gave_up_hook(nil, _client_id, _error_class), do: :ok

  defp call_gave_up_hook({module, function, args}, client_id, error_class) do
    apply(module, function, args ++ [client_id, error_class])
  rescue
    exception ->
      Logger.error("on_refresh_gave_up hook failed: #{Exception.format(:error, exception)}")
  end

  defp classify({:unexpected_response, status, body}), do: classify_response(status, body)
  defp classify({:request_failed, _exception}), do: :transient

  defp classify_response(status, body) when status in [400, 401] do
    if body_error(body) == "invalid_grant", do: :invalid_refresh_token, else: :transient
  end

  defp classify_response(403, _body), do: :client_blacklisted
  defp classify_response(429, _body), do: :rate_limited
  defp classify_response(_status, _body), do: :transient

  defp body_error(body) when is_map(body), do: Map.get(body, "error")
  defp body_error(_body), do: nil

  defp failure_state(client_id, refresh_token) do
    case :ets.lookup(@refresh_failures_table, {client_id, refresh_token}) do
      [{_key, state}] -> state
      [] -> nil
    end
  end

  defp record_failure(client_id, refresh_token, error_class) do
    failure_count = failure_count(client_id, refresh_token) + 1
    next_retry_at = next_retry_at(error_class, failure_count)

    :ets.insert(
      @refresh_failures_table,
      {{client_id, refresh_token}, {error_class, failure_count, next_retry_at}}
    )

    failure_count
  end

  defp failure_count(client_id, refresh_token) do
    case failure_state(client_id, refresh_token) do
      {_error_class, failure_count, _next_retry_at} -> failure_count
      nil -> 0
    end
  end

  defp next_retry_at(:invalid_refresh_token, _failure_count), do: :infinity
  defp next_retry_at(:client_blacklisted, _failure_count), do: :infinity

  defp next_retry_at(:rate_limited, failure_count),
    do: deadline(rate_limit_delay_ms(failure_count))

  defp next_retry_at(:transient, failure_count) do
    if failure_count >= @transient_failures_before_cooldown do
      deadline(@cooldown_ms)
    else
      deadline(jittered_backoff_ms(failure_count))
    end
  end

  defp rate_limit_delay_ms(failure_count) do
    min(@rate_limit_base_ms * 2 ** (failure_count - 1), @rate_limit_cap_ms)
  end

  defp jittered_backoff_ms(failure_count) do
    (@base_backoff_ms * 2 ** (failure_count - 1))
    |> min(@backoff_cap_ms)
    |> jitter()
  end

  defp jitter(ms), do: trunc(ms * (0.8 + 0.4 * :rand.uniform()))

  defp deadline(ms), do: System.system_time(:millisecond) + ms
end
