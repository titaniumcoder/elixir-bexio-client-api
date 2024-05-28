defmodule BexioApiClientTest do
  use ExUnit.Case, async: true

  doctest BexioApiClient

  describe "client creation with token" do
    test "will create a client and respect the options" do
      %Req.Request{} = req = BexioApiClient.new("my-api-token")

      assert "application/json" in req.headers["accept"]
      assert "application/json" in req.headers["content-type"]

      assert req.options[:retry] == &BexioApiClient.Req.RewriteDelay.retry/2
      assert {:bearer, _} = req.options[:auth]
    end
  end

  describe "will handle variants of the refresh token flow" do
    test "will correctly handle a correct response" do
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

      {:ok, access_token, expires_in} = BexioApiClient.access_token("r1", "c1", "c2")
      assert access_token == "access_token"
      assert expires_in == 3599
    end

    test "will handle unauthorized response" do
      Req.Test.stub(BexioApiClient, fn conn ->
        send_resp(conn, 401, Jason.encode!(%{"error" => "unknown content"}))
      end)

      assert BexioApiClient.access_token("r2", "c1", "c2") == {:error, :unauthenticated}
    end

    test "will handle invalid response" do
      Req.Test.stub(BexioApiClient, fn conn ->
        Req.Test.json(conn, %{
          "expires_in" => 3599,
          "id_token" => "id_token",
          "refresh_token" => "refresh_token",
          "scope" => "scope",
          "token_type" => "Bearer"
        })
      end)

      assert {:error, {:unexpected_response, _}} = BexioApiClient.access_token("r3", "c1", "c2")
    end
  end

  defp send_resp(conn, status, body) do
    Plug.Conn.send_resp(conn, status, body)
  end
end
