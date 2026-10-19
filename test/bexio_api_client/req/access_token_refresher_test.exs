defmodule BexioApiClient.Req.AccessTokenRefresherTest do
  use ExUnit.Case, async: true

  use TestHelper

  alias BexioApiClient.Req.AccessTokenRefresher

  @access_tokens_table :bexio_api_client_access_tokens
  @refresh_failures_table :bexio_api_client_refresh_failures

  describe "attach" do
    test "registers all options and prepends the request step" do
      req =
        AccessTokenRefresher.attach(%Req.Request{},
          refresh_token: "refresh",
          client_id: "client_id",
          client_secret: "client_secret"
        )

      assert Req.Request.get_option(req, :refresh_token) == "refresh"
      assert Req.Request.get_option(req, :client_id) == "client_id"
      assert Req.Request.get_option(req, :client_secret) == "client_secret"

      assert [{:get_access_token, _}] = req.request_steps
    end
  end

  describe "token caching" do
    test "stores the access token with its expiry" do
      counter = new_counter()

      stub_token_endpoint(counter, fn conn, _call ->
        token_response(conn, "initial")
      end)

      req = new_client("cid-store", "initial")
      assert {:ok, _} = Req.get(req, url: "/test")

      assert [{{"cid-store", "initial"}, {"access_token_initial", expires_at}}] =
               :ets.lookup(@access_tokens_table, {"cid-store", "initial"})

      assert expires_at > System.system_time(:second)
      assert calls(counter) == 1
    end

    test "reuses the cached token on subsequent requests" do
      counter = new_counter()

      stub_token_endpoint(counter, fn conn, _call ->
        token_response(conn, "initial")
      end)

      req = new_client("cid-replay", "initial")
      assert {:ok, _} = Req.get(req, url: "/test")
      assert {:ok, _} = Req.get(req, url: "/test")

      assert last_resource_auth(counter) == ["Bearer access_token_initial"]
      assert calls(counter) == 1
    end

    test "does not treat a changed refresh token in the response as rotation" do
      counter = new_counter()

      stub_token_endpoint(counter, fn conn, _call ->
        token_response(conn, "different")
      end)

      req = new_client("cid-norotate", "initial")
      assert {:ok, _} = Req.get(req, url: "/test")
      assert {:ok, _} = Req.get(req, url: "/test")

      assert :ets.lookup(@access_tokens_table, {"cid-norotate", "different"}) == []

      assert [{{"cid-norotate", "initial"}, {"access_token_different", _expires_at}}] =
               :ets.lookup(@access_tokens_table, {"cid-norotate", "initial"})

      assert calls(counter) == 1
    end
  end

  describe "refresh failures" do
    test "halts the request instead of sending it unauthenticated when the refresh fails" do
      counter = new_counter()

      stub_token_endpoint(counter, fn conn, _call ->
        json_response(conn, 401, %{"error" => "unknown content"})
      end)

      req = new_client("cid-halt", "dead")

      assert {:error,
              %BexioApiClient.RefreshError{
                reason: {:transient, {:unexpected_response, 401, %{"error" => "unknown content"}}}
              }} = Req.get(req, url: "/test")

      assert calls(counter) == 1
      assert last_resource_auth(counter) == nil
    end

    test "never retries after an invalid_grant response and fails fast afterwards" do
      counter = new_counter()

      stub_token_endpoint(counter, fn conn, _call ->
        json_response(conn, 400, %{"error" => "invalid_grant"})
      end)

      req = new_client("cid-invalid", "dead")

      assert {:error,
              %BexioApiClient.RefreshError{
                reason:
                  {:invalid_refresh_token,
                   {:unexpected_response, 400, %{"error" => "invalid_grant"}}}
              }} = Req.get(req, url: "/test")

      assert calls(counter) == 1

      assert {:error,
              %BexioApiClient.RefreshError{
                reason: {:refresh_backoff, :invalid_refresh_token, :infinity}
              }} = Req.get(req, url: "/test")

      assert calls(counter) == 1
    end

    test "never retries after a blacklisted response and fails fast afterwards" do
      counter = new_counter()

      stub_token_endpoint(counter, fn conn, _call ->
        json_response(conn, 403, %{"reason" => "blacklisted", "status" => "blocked"})
      end)

      req = new_client("cid-blacklisted", "dead")

      assert {:error,
              %BexioApiClient.RefreshError{
                reason:
                  {:client_blacklisted,
                   {:unexpected_response, 403,
                    %{"reason" => "blacklisted", "status" => "blocked"}}}
              }} = Req.get(req, url: "/test")

      assert calls(counter) == 1

      assert {:error,
              %BexioApiClient.RefreshError{
                reason: {:refresh_backoff, :client_blacklisted, :infinity}
              }} = Req.get(req, url: "/test")

      assert calls(counter) == 1
    end

    test "backs off after a transient server error" do
      counter = new_counter()

      stub_token_endpoint(counter, fn conn, _call ->
        json_response(conn, 500, %{"oops" => true})
      end)

      req = new_client("cid-transient", "tok")

      assert {:error,
              %BexioApiClient.RefreshError{
                reason: {:transient, {:unexpected_response, 500, %{"oops" => true}}}
              }} = Req.get(req, url: "/test")

      assert [{_, {:transient, 1, next_retry_at}}] =
               :ets.lookup(@refresh_failures_table, {"cid-transient", "tok"})

      assert (next_retry_at - System.system_time(:millisecond)) in 0..600

      assert {:error,
              %BexioApiClient.RefreshError{reason: {:refresh_backoff, :transient, retry_in_ms}}} =
               Req.get(req, url: "/test")

      assert is_integer(retry_in_ms)
      assert calls(counter) == 1
    end

    test "re-enables refresh after clear_refresh_failure/1" do
      counter = new_counter()

      stub_token_endpoint(counter, fn conn, call ->
        if call == 1 do
          json_response(conn, 400, %{"error" => "invalid_grant"})
        else
          token_response(conn, "fresh")
        end
      end)

      req = new_client("cid-clear", "dead")
      assert {:error, %BexioApiClient.RefreshError{}} = Req.get(req, url: "/test")

      :ok = AccessTokenRefresher.clear_refresh_failure("cid-clear")

      assert {:ok, _} = Req.get(req, url: "/test")
      assert calls(counter) == 2
    end

    test "calls on_refresh_gave_up once when a permanent failure occurs" do
      counter = new_counter()

      stub_token_endpoint(counter, fn conn, _call ->
        json_response(conn, 400, %{"error" => "invalid_grant"})
      end)

      req =
        new_client("cid-gaveup-permanent", "dead",
          on_refresh_gave_up: {__MODULE__, :record_gave_up, [self()]}
        )

      assert {:error, %BexioApiClient.RefreshError{}} = Req.get(req, url: "/test")
      assert_received {:refresh_gave_up, "cid-gaveup-permanent", :invalid_refresh_token}

      assert {:error, %BexioApiClient.RefreshError{}} = Req.get(req, url: "/test")
      refute_received {:refresh_gave_up, _, _}
    end

    test "calls on_refresh_gave_up once when transient failures reach the cooldown" do
      counter = new_counter()

      stub_token_endpoint(counter, fn conn, _call ->
        json_response(conn, 500, %{"oops" => true})
      end)

      AccessTokenRefresher.create_ets_table()

      :ets.insert(
        @refresh_failures_table,
        {{"cid-gaveup-transient", "tok"}, {:transient, 4, System.system_time(:millisecond) - 1}}
      )

      req =
        new_client("cid-gaveup-transient", "tok",
          on_refresh_gave_up: {__MODULE__, :record_gave_up, [self()]}
        )

      assert {:error, %BexioApiClient.RefreshError{}} = Req.get(req, url: "/test")
      assert_received {:refresh_gave_up, "cid-gaveup-transient", :transient}

      assert {:error, %BexioApiClient.RefreshError{}} = Req.get(req, url: "/test")
      refute_received {:refresh_gave_up, _, _}
    end

    test "emits a failure telemetry event with the error class and failure count" do
      counter = new_counter()

      stub_token_endpoint(counter, fn conn, _call ->
        json_response(conn, 400, %{"error" => "invalid_grant"})
      end)

      attach_telemetry([:bexio_api_client, :refresh, :failed])

      req = new_client("cid-failed-tele", "dead")
      assert {:error, %BexioApiClient.RefreshError{}} = Req.get(req, url: "/test")

      assert_receive {:telemetry, [:bexio_api_client, :refresh, :failed], %{count: 1},
                      %{error_class: :invalid_refresh_token, failure_count: 1}}
    end
  end

  describe "expired token cleanup" do
    test "removes expired entries and keeps live ones" do
      AccessTokenRefresher.create_ets_table()
      now = System.system_time(:second)

      :ets.insert(@access_tokens_table, {{"cid-exp", "expired"}, {"at", now - 1}})
      :ets.insert(@access_tokens_table, {{"cid-exp", "live"}, {"at", now + 3600}})

      :ok = BexioApiClient.remove_expired_access_tokens()

      assert :ets.lookup(@access_tokens_table, {"cid-exp", "expired"}) == []
      assert :ets.lookup(@access_tokens_table, {"cid-exp", "live"}) != []
    end
  end

  def record_gave_up(pid, client_id, error_class) do
    send(pid, {:refresh_gave_up, client_id, error_class})
  end

  defp new_counter do
    :ets.new(:token_endpoint_calls, [:set, :public])
  end

  defp bump(counter) do
    :ets.update_counter(counter, :calls, 1, {:calls, 0})
  end

  defp calls(counter) do
    case :ets.lookup(counter, :calls) do
      [{:calls, calls}] -> calls
      [] -> 0
    end
  end

  defp last_resource_auth(counter) do
    case :ets.lookup(counter, :last_resource_auth) do
      [{:last_resource_auth, auth}] -> auth
      [] -> nil
    end
  end

  defp stub_token_endpoint(counter, respond) do
    Req.Test.stub(BexioApiClient, fn conn ->
      if token_endpoint_request?(conn) do
        respond.(conn, bump(counter))
      else
        :ets.insert(
          counter,
          {:last_resource_auth, Plug.Conn.get_req_header(conn, "authorization")}
        )

        Req.Test.json(conn, %{"resource" => "ok"})
      end
    end)
  end

  defp token_endpoint_request?(conn) do
    case Plug.Conn.get_req_header(conn, "authorization") do
      ["Basic " <> _] -> true
      _ -> false
    end
  end

  defp new_client(client_id, refresh_token, opts \\ []) do
    BexioApiClient.new(client_id, "secret", refresh_token, opts)
  end

  defp token_response(conn, refresh_token) do
    Req.Test.json(conn, %{
      "access_token" => "access_token_#{refresh_token}",
      "expires_in" => 3599,
      "id_token" => "id_token",
      "refresh_token" => refresh_token,
      "scope" => "scope",
      "token_type" => "Bearer"
    })
  end

  defp json_response(conn, status, body) do
    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> Plug.Conn.send_resp(status, Jason.encode!(body))
  end

  defp attach_telemetry(event) do
    handler_id = {:refresher_test, System.unique_integer()}
    test_pid = self()

    :telemetry.attach(
      handler_id,
      event,
      fn event, measurements, metadata, _config ->
        send(test_pid, {:telemetry, event, measurements, metadata})
      end,
      nil
    )

    on_exit(fn -> :telemetry.detach(handler_id) end)
    handler_id
  end
end
