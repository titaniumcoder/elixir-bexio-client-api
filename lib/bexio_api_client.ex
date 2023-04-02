defmodule BexioApiClient do
  @moduledoc """
  Base Module for the API Client.

  The API Documentation for Bexio can be found under https://docs.bexio.com.

  Fields or arguments with date time reference expect them in the time zone Europe/Zurich.

  ## Requirements:

    * Tesla: the api client depends on Tesla. Every API call needs an instance of a `Tesla.Client` to be able to do the rest calls.any()

  """

  @doc """
  Create Tesla API Client.

  This must be given a token from https://office.bexio.com/admin/apiTokens#/ which will then be used as bearer token.
  The client can then be used everywhere where it's useful.

  It also allows an optional setup for retrying to allow to limit if needed. The defaults are listed below:

  * :delay (500)
  * :max_retries (10)
  * :max_delay (4_000)
  * :log_level (:info)
  * :debug (false)
  * :adapter (nil)

  """
  @spec create_client(String.t(), keyword()) :: Tesla.Client.t()
  def create_client(api_token, opts \\ []) do
    delay = Keyword.get(opts, :delay, 500)
    max_retries = Keyword.get(opts, :max_retries, 10)
    max_delay = Keyword.get(opts, :max_delay, 4_000)
    log_level = Keyword.get(opts, :log_level, :info)
    adapter = Keyword.get(opts, :adapter)
    debug = Keyword.get(opts, :debug, false)

    middleware = [
      {Tesla.Middleware.BaseUrl, "https://api.bexio.com"},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.BearerAuth, token: api_token},
      {Tesla.Middleware.Headers, [{"accept", "application/json"}]},
      {Tesla.Middleware.Logger,
       log_level: log_level, filter_headers: ["authorization"], debug: debug},
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
