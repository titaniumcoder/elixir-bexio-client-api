defmodule BexioApiClientTest do
  use ExUnit.Case, async: true
  doctest BexioApiClient

  import Tesla.Mock

  describe "client creation with token" do
    test "will create a client and respect the options" do
      %Tesla.Client{pre: pre} =
        BexioApiClient.new("a-very-long-token",
          delay: 1000,
          max_delay: 100_000,
          max_retries: 20,
          log_level: :warn
        )

      assert extract_pre(pre, Tesla.Middleware.BaseUrl) == ["https://api.bexio.com"]
      assert extract_pre(pre, Tesla.Middleware.JSON) == [[]]
      assert extract_pre(pre, Tesla.Middleware.BearerAuth) == [[token: "a-very-long-token"]]

      assert extract_pre(pre, Tesla.Middleware.Logger) == [
               [log_level: :warn, filter_headers: ["authorization"], debug: false]
             ]

      [retry_keywords] = extract_pre(pre, Tesla.Middleware.Retry)
      assert Keyword.get(retry_keywords, :delay) == 1_000

      assert Keyword.get(retry_keywords, :max_retries) == 20
      assert Keyword.get(retry_keywords, :max_delay) == 100_000
    end

    defp extract_pre(pre, type) do
      {_, _, content} =
        Enum.find(
          pre,
          fn
            {^type, :call, _content} -> true
            _ -> false
          end
        )

      content
    end
  end

  describe "will handle variants of the refresh token flow" do
    setup do
      mock(fn
        %{method: :post, url: "https://idp.bexio.com/token", body: body} ->
          token = URI.decode_query(body)["refresh_token"]

          case token do
            "r1" ->
              json(%{
                "access_token" => "access_token",
                "expires_in" => 3599,
                "id_token" => "id_token",
                "refresh_token" => "refresh_token",
                "scope" => "scope",
                "token_type" => "Bearer"
              })

            "r2" ->
              %Tesla.Env{status: 401, body: "unknown token"}

            "r3" ->
              json(%{
                "expires_in" => 3599,
                "id_token" => "id_token",
                "refresh_token" => "refresh_token",
                "scope" => "scope",
                "token_type" => "Bearer"
              })
          end
      end)

      :ok
    end

    test "will correctly handle a correct response" do
      {:ok, tokens} = BexioApiClient.access_token("r1", "c1", "c2", Tesla.Mock)
      assert tokens.access_token == "access_token"
      assert tokens.expires_in == 3599
      assert tokens.id_token == "id_token"
      assert tokens.refresh_token == "refresh_token"
      assert tokens.scope == "scope"
      assert tokens.token_type == "Bearer"
    end

    test "will handle unauthorized response" do
      assert BexioApiClient.access_token("r2", "c1", "c2", Tesla.Mock) == {:error, :unauthorized}
    end

    test "will handle invalid response" do
      assert {:error, {:unexpected_response, _}} = BexioApiClient.access_token("r3", "c1", "c2", Tesla.Mock)
    end
  end
end
