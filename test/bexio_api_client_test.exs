defmodule BexioApiClientTest do
  use ExUnit.Case, async: true

  use TestHelper

  doctest BexioApiClient

  describe "client creation with token" do
    test "will create a client and respect the options" do
      %Req.Request{} = req = BexioApiClient.new("my-api-token")

      assert "application/json" in req.headers["accept"]
      assert "application/json" in req.headers["content-type"]

      assert req.options[:retry] == (&BexioApiClient.Req.RewriteDelay.retry/2)
      assert {:bearer, _} = req.options[:auth]
    end
  end

  describe "will handle variants of the refresh token flow" do
    test "returns the full token map including the rotated refresh token" do
      Req.Test.stub(BexioApiClient, fn conn ->
        Req.Test.json(conn, %{
          "access_token" => "access_token",
          "expires_in" => 3599,
          "id_token" => "id_token",
          "refresh_token" => "rotated_refresh_token",
          "scope" => "scope",
          "token_type" => "Bearer"
        })
      end)

      assert BexioApiClient.access_token("r1", "c1", "c2") ==
               {:ok,
                %{
                  access_token: "access_token",
                  expires_in: 3599,
                  id_token: "id_token",
                  refresh_token: "rotated_refresh_token",
                  scope: "scope",
                  token_type: "Bearer"
                }}
    end

    test "returns nil for optional fields that the response does not contain" do
      Req.Test.stub(BexioApiClient, fn conn ->
        Req.Test.json(conn, %{
          "access_token" => "access_token",
          "expires_in" => 3599
        })
      end)

      assert BexioApiClient.access_token("r2", "c1", "c2") ==
               {:ok,
                %{
                  access_token: "access_token",
                  expires_in: 3599,
                  id_token: nil,
                  refresh_token: nil,
                  scope: nil,
                  token_type: nil
                }}
    end

    test "returns status and body when the response is unexpected" do
      Req.Test.stub(BexioApiClient, fn conn ->
        json_response(conn, 401, %{"error" => "unknown content"})
      end)

      assert BexioApiClient.access_token("r3", "c1", "c2") ==
               {:error, {:unexpected_response, 401, %{"error" => "unknown content"}}}
    end

    test "returns status and body when a blacklisted response is received" do
      Req.Test.stub(BexioApiClient, fn conn ->
        json_response(conn, 403, %{"reason" => "blacklisted", "status" => "blocked"})
      end)

      assert BexioApiClient.access_token("r4", "c1", "c2") ==
               {:error,
                {:unexpected_response, 403, %{"reason" => "blacklisted", "status" => "blocked"}}}
    end

    test "returns status and body when a 200 response has an unexpected body" do
      Req.Test.stub(BexioApiClient, fn conn ->
        Req.Test.json(conn, %{
          "expires_in" => 3599,
          "id_token" => "id_token",
          "refresh_token" => "refresh_token",
          "scope" => "scope",
          "token_type" => "Bearer"
        })
      end)

      assert {:error,
              {:unexpected_response, 200, %{"expires_in" => 3599, "id_token" => "id_token"}}} =
               BexioApiClient.access_token("r5", "c1", "c2")
    end
  end

  defp json_response(conn, status, body) do
    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> Plug.Conn.send_resp(status, Jason.encode!(body))
  end
end
