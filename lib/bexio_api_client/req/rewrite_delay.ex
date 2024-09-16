defmodule BexioApiClient.Req.RewriteDelay do
  require Logger

  @moduledoc """
  This module just handles the normal Bexio API rate limit headers as well as the (observed) regular exceptions to retry.
  With status code 429 we try to read the header "ratelimit-reset" and send back the {:delay, delay} tuple.
  In case of 408, 500, 502, 503, 504 we fall back to the retry mechanism.
  """

  # RateLimit-Reset
  @spec retry(Req.Request.t(), any()) :: boolean() | {:delay, integer()}
  def retry(%Req.Request{} = request, response_or_exception) do
    case response_or_exception do
      %Req.Response{status: 429, headers: headers} ->
        case headers do
          %{"ratelimit-reset" => [reset]} ->
            {:delay, String.to_integer(reset) * 1000}

          _ ->
            Logger.warning(
              "No ratelimit-reset header found in #{inspect(headers)}, falling back to default retry mechanism."
            )

            true
        end

      %Req.Response{status: status} when status in [408, 500, 502, 503, 504] ->
        Logger.debug("Retrying request #{inspect(request)} due to status #{status}")
        true

      %Req.Response{} ->
        false

      _ ->
        true
    end
  end
end
