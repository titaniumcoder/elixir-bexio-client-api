defmodule BexioApiClient.Req.RewriteDelay do
  require Logger

  @moduledoc """
  This module just handles the normal Bexio API rate limit headers as well as the (observed) regular exceptions to retry.
  With status code 429 we try to read the header "ratelimit-reset" and send back the {:delay, delay} tuple.
  In case of 408, 500, 502, 503, 504 we fall back to the retry mechanism.

  ## Telemetry Events

  This module emits the following telemetry events:

    * `[:bexio_api_client, :rate_limit, :hit]` - Emitted when a 429 rate limit response is received.
      Measurements: `%{reset_seconds: integer()}`
      Metadata: `%{has_reset_header: boolean()}`

    * `[:bexio_api_client, :request, :retry]` - Emitted when a request will be retried due to server errors.
      Measurements: `%{count: 1}`
      Metadata: `%{status: integer()}`

    * `[:bexio_api_client, :request, :success]` - Emitted when a request completes successfully (status 200-399).
      Measurements: `%{count: 1}`
      Metadata: `%{status: integer()}`

    * `[:bexio_api_client, :request, :error]` - Emitted when a request completes with an error (status 400+).
      Measurements: `%{count: 1}`
      Metadata: `%{status: integer()}`
  """

  # RateLimit-Reset
  @spec retry(Req.Request.t(), any()) :: boolean() | {:delay, integer()}
  def retry(%Req.Request{} = request, response_or_exception) do
    case response_or_exception do
      %Req.Response{status: 429, headers: headers} ->
        case headers do
          %{"ratelimit-reset" => [reset]} ->
            reset_seconds = String.to_integer(reset)

            :telemetry.execute(
              [:bexio_api_client, :rate_limit, :hit],
              %{reset_seconds: reset_seconds},
              %{has_reset_header: true}
            )

            {:delay, reset_seconds * 1000}

          _ ->
            Logger.warning(
              "No ratelimit-reset header found in #{inspect(headers)}, falling back to default retry mechanism."
            )

            :telemetry.execute(
              [:bexio_api_client, :rate_limit, :hit],
              %{reset_seconds: 0},
              %{has_reset_header: false}
            )

            true
        end

      %Req.Response{status: status} when status in [408, 500, 502, 503, 504] ->
        Logger.debug("Retrying request #{inspect(request)} due to status #{status}")

        :telemetry.execute(
          [:bexio_api_client, :request, :retry],
          %{count: 1},
          %{status: status}
        )

        true

      %Req.Response{status: status} when status >= 200 and status < 400 ->
        :telemetry.execute(
          [:bexio_api_client, :request, :success],
          %{count: 1},
          %{status: status}
        )

        false

      %Req.Response{status: status} ->
        :telemetry.execute(
          [:bexio_api_client, :request, :error],
          %{count: 1},
          %{status: status}
        )

        false

      _ ->
        true
    end
  end
end
