defmodule BexioApiClientTest do
  use ExUnit.Case, async: true
  doctest BexioApiClient

  test "will create a client and respect the options" do
    %Tesla.Client{pre: pre} =
      BexioApiClient.create_client("a-very-long-token",
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
