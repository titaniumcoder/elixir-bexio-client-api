defmodule BexioApiClient do
  @moduledoc """
  Base Module for the API Client
  """

  @doc """
  Create Tesla API Client.

  This must be given a token from https://office.bexio.com/admin/apiTokens#/ which will then be used as bearer token.
  The client can then be used everywhere where it's useful.

  It also allows an optional setup for retrying to allow to limit if needed. The defaults are listed below:

  * :delay (500)
  * :max_retries (10)
  * :max_delay (4_000)
  * :log_level (:error)

  """
  @spec create_client(String.t(), keyword()) :: Tesla.Client.t()
  def create_client(api_token, opts \\ []) do
    delay = Keyword.get(opts, :delay, 500)
    max_retries = Keyword.get(opts, :max_retries, 10)
    max_delay = Keyword.get(opts, :max_delay, 4_000)
    log_level = Keyword.get(opts, :log_level, :error)
    adapter = Keyword.get(opts, :adapter)
    debug = Keyword.get(opts, :debug, false)

    middleware = [
      {Tesla.Middleware.BaseUrl, "https://api.bexio.com"},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.BearerAuth, token: api_token},
      {Tesla.Middleware.Headers, [{"accept", "application/json"}]},
      {Tesla.Middleware.Logger, log_level: log_level, filter_headers: ["authorization"], debug: debug},
      {Tesla.Middleware.Retry,
       delay: delay,
       max_retries: max_retries,
       max_delay: max_delay,
       should_retry: fn
         {:ok, %{status: status}} when status in [500, 503, 429] -> true
         {:ok, _} -> false
         {:error, _} -> true
       end}
    ]

    Tesla.client(middleware, adapter)
  end
end
