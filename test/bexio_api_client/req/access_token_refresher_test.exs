defmodule BexioApiClient.Req.AccessTokenRefresherTest do
  use ExUnit.Case, async: true

  use TestHelper

  alias BexioApiClient.Req.AccessTokenRefresher

  describe "should attach it correctly" do
    test "should have all options set" do
      req =
        AccessTokenRefresher.attach(%Req.Request{},
          refresh_token: "refresh",
          client_id: "client_id",
          client_secret: "client_secret"
        )

      assert Req.Request.get_option(req, :refresh_token) == "refresh"
      assert Req.Request.get_option(req, :client_id) == "client_id"
      assert Req.Request.get_option(req, :client_secret) == "client_secret"

      [{name, _}] = req.request_steps
      assert name == :get_access_token
    end
  end

  describe "should handle access token logic correctly" do
    test "should take the correct api token and store it in ETS" do
      Req.Test.stub(BexioApiClient, fn conn ->
        Req.Test.json(conn, %{
          "access_token" => "access_token",
          "expires_in" => 3599,
          "id_token" => "id_token",
          "refresh_token" => "refresh_token",
          "scope" => "scope",
          "token_type" => "Bearer"
        })
      end)

      _ = AccessTokenRefresher.create_ets_table()

      req = BexioApiClient.new("client_id", "client_secret", "refresh_token")

      _ = Req.get(req, url: "/test")

      result = :ets.lookup(:bexio_api_client_access_tokens, {"client_id", "refresh_token"})
      [{{"client_id", "refresh_token"}, {"access_token", x}}] = result
      assert System.system_time(:second) + 3600 > x

    end

    test "should do nothing if there is no correct answer from the server" do
      Req.Test.stub(BexioApiClient, fn conn ->
        send_resp(conn, 401, Jason.encode!(%{"error" => "unknown content"}))
      end)

      _ = AccessTokenRefresher.create_ets_table()

      req = BexioApiClient.new("client_id1", "client_secret1", "refresh_token1")

      _ = Req.get(req, url: "/test")

      result = :ets.lookup(:bexio_api_client_access_tokens, {"client_id1", "refresh_token1"})
      assert result == []
    end
  end
end
