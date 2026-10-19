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
  Req request step that fetches, caches and rotates access tokens for Bexio
  OAuth2 clients.

  The access token cache lives in the ETS table `:bexio_api_client_access_tokens`
  and is keyed by `{client_id, refresh_token}`. Each entry stores
  `{access_token, expires_at, current_refresh_token}`, because Bexio (Keycloak)
  MAY rotate refresh tokens: a token response can contain a NEW `refresh_token`
  which invalidates the previously used one. Rotation has not been observed so
  far, but Keycloak realms can enable it at any time, so it is handled
  defensively: when a rotation is observed, the entry under the previously
  requested key is updated in place (so requests that still carry the old
  refresh token keep working) and an additional entry under the new refresh
  token is written.

  Host applications SHOULD persist a rotated refresh token when they receive one.
  Use the `:on_refresh_token_rotated` option (`{module, function, args}`, invoked
  as `apply(module, function, args ++ [client_id, new_refresh_token])`) or hook
  the `[:bexio_api_client, :refresh_token_rotated]` telemetry event. Telemetry
  metadata contains only short token hashes, never the token values.

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

  ## Telemetry events

    * `[:bexio_api_client, :refresh_token_rotated]` - a refresh token was rotated.
      Measurements: `%{count: 1}`. Metadata:
      `%{client_id: client_id, old_refresh_token_hash: hash, new_refresh_token_hash: hash}`
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
      :on_refresh_token_rotated
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
        _ = :ets.new(name, [:named_table, :set, :public])
        :ok

      _table ->
        :ok
    end
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
      |> :ets.match({:"$0", {:_, :"$1", :_}})
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
      {:fresh, access_token, current} ->
        continue_with_token(request, current, access_token)

      {:stale, current} ->
        refresh(request, client_id, refresh_token, current)

      :miss ->
        refresh(request, client_id, refresh_token, refresh_token)
    end
  end

  defp lookup_entry(client_id, refresh_token) do
    now = System.system_time(:second)

    case :ets.lookup(@access_tokens_table, {client_id, refresh_token}) do
      [{_key, {access_token, expires_at, current}}] when expires_at > now ->
        {:fresh, access_token, current}

      [{_key, {_access_token, _expires_at, current}}] ->
        {:stale, current}

      [] ->
        :miss
    end
  end

  defp continue_with_token(request, current_refresh_token, access_token) do
    request
    |> Req.Request.merge_options(refresh_token: current_refresh_token)
    |> use_access_token(access_token)
  end

  defp use_access_token(request, access_token) do
    Req.Request.merge_options(request, auth: {:bearer, access_token})
  end

  defp refresh(request, client_id, requested_token, effective_token) do
    if backoff_active?(client_id, effective_token) do
      fail_fast(request, client_id, effective_token)
    else
      locked_refresh(request, client_id, requested_token, effective_token)
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

  defp locked_refresh(request, client_id, requested_token, effective_token) do
    if acquire_lock(client_id, effective_token) do
      try do
        fetch_and_apply(request, client_id, requested_token, effective_token)
      after
        release_lock(client_id, effective_token)
      end
    else
      wait_or_refresh(request, client_id, requested_token, effective_token)
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

  defp wait_or_refresh(request, client_id, requested_token, effective_token) do
    case wait_for_fresh_entry(client_id, effective_token) do
      {access_token, current} ->
        continue_with_token(request, current, access_token)

      :timeout ->
        locked_refresh(request, client_id, requested_token, effective_token)
    end
  end

  defp wait_for_fresh_entry(client_id, refresh_token) do
    deadline = System.system_time(:millisecond) + @max_wait_ms
    do_wait_for_fresh_entry(client_id, refresh_token, deadline)
  end

  defp do_wait_for_fresh_entry(client_id, refresh_token, deadline) do
    case lookup_entry(client_id, refresh_token) do
      {:fresh, access_token, current} ->
        {access_token, current}

      _ ->
        if System.system_time(:millisecond) >= deadline do
          :timeout
        else
          Process.sleep(@wait_step_ms)
          do_wait_for_fresh_entry(client_id, refresh_token, deadline)
        end
    end
  end

  defp fetch_and_apply(request, client_id, requested_token, effective_token) do
    client_secret = Req.Request.get_option(request, :client_secret)

    case BexioApiClient.access_token(effective_token, client_id, client_secret) do
      {:ok, token} ->
        apply_success(request, client_id, requested_token, effective_token, token)

      {:error, reason} ->
        apply_failure(request, client_id, effective_token, reason)
    end
  end

  defp apply_success(request, client_id, requested_token, effective_token, token) do
    expires_at = System.system_time(:second) + token.expires_in - @expires_in_reserve
    new_current = token.refresh_token || effective_token

    store_tokens(client_id, requested_token, new_current, token.access_token, expires_at)

    propagate_rotation(client_id, effective_token, new_current, token.access_token, expires_at)
    notify_rotation(request, client_id, effective_token, new_current)

    request
    |> Req.Request.merge_options(refresh_token: new_current)
    |> use_access_token(token.access_token)
  end

  defp store_tokens(client_id, requested_token, current, access_token, expires_at) do
    entry = {access_token, expires_at, current}
    :ets.insert(@access_tokens_table, {{client_id, requested_token}, entry})

    if current != requested_token do
      :ets.insert(@access_tokens_table, {{client_id, current}, entry})
    end
  end

  defp propagate_rotation(client_id, old_current, new_current, access_token, expires_at) do
    entry = {access_token, expires_at, new_current}

    @access_tokens_table
    |> :ets.match_object({{client_id, :_}, {access_token, expires_at, old_current}})
    |> Enum.each(fn {key, _stale_entry} -> :ets.insert(@access_tokens_table, {key, entry}) end)
  end

  defp notify_rotation(request, client_id, old_current, new_current) do
    if new_current != old_current do
      :telemetry.execute(
        [:bexio_api_client, :refresh_token_rotated],
        %{count: 1},
        %{
          client_id: client_id,
          old_refresh_token_hash: hash_token(old_current),
          new_refresh_token_hash: hash_token(new_current)
        }
      )

      request
      |> Req.Request.get_option(:on_refresh_token_rotated)
      |> call_rotation_hook(client_id, new_current)
    end
  end

  defp hash_token(token) do
    :crypto.hash(:sha256, token)
    |> Base.encode16(case: :lower)
    |> binary_part(0, 12)
  end

  defp call_rotation_hook(nil, _client_id, _new_refresh_token), do: :ok

  defp call_rotation_hook({module, function, args}, client_id, new_refresh_token) do
    apply(module, function, args ++ [client_id, new_refresh_token])
  rescue
    exception ->
      Logger.error("on_refresh_token_rotated hook failed: #{Exception.format(:error, exception)}")
  end

  defp apply_failure(request, client_id, effective_token, reason) do
    error_class = classify(reason)
    failure_count = record_failure(client_id, effective_token, error_class)

    :telemetry.execute(
      [:bexio_api_client, :refresh, :failed],
      %{count: 1},
      %{error_class: error_class, failure_count: failure_count}
    )

    Logger.error("Access token refresh failed (#{error_class}): #{inspect(reason)}")

    Req.Request.halt(request, %BexioApiClient.RefreshError{reason: {error_class, reason}})
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
