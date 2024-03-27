defmodule BexioApiClient do
  @moduledoc """
  Base Module for the API Client.

  The API Documentation for Bexio can be found under https://docs.bexio.com.

  Fields or arguments with date time reference expect them in the time zone Europe/Zurich.

  ## Requirements:

    * Http Client:
    ** Req: the api client depends on Req.

  """

  alias BexioApiClient.Requests.BexioAuth

  @doc """
  Create a Req that can be used to call the Bexio API with the correct headers and everything prepared when the input is an API Token (https://office.bexio.com/index.php/admin/apiTokens)

  Rate Limits:

  Bexio APIs are rate limited, using 429 to indicate too many requests.

  Retries: there are automatic retries on the following status codes:

  * 500, 502, 503: server errors that probably will be fixed. will use an exponential backoff if possible for the retries to give the server time to recover
  * 429 will be handled using the header ratelimit-reset if available else waiting for 1 minute
  """
  def create_req(api_token, opts \\ []) do
    # TODO improve logic for 429 replies where I want to wait for 1 minute!
    jitter_delay_function = fn n ->
      trunc(Integer.pow(2, n) * 1000 * (1 - 0.1 * :rand.uniform()))
    end

    req =
      Req.new(
        base_url: "https://api.bexio.com",
        retry_delay: jitter_delay_function,
        auth: {:bearer, api_token},
        headers: {"accept", "application/json"}
      )
  end
end
