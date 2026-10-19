defmodule BexioApiClient.Req.RetryPolicy do
  @moduledoc """
  Behaviour for deciding whether and when to retry a Bexio API request.

  The default implementation is `BexioApiClient.Req.RewriteDelay`, which honors
  Bexio's `ratelimit-reset` header on 429 responses, retries transient server
  errors (408, 500, 502, 503, 504) and `Req.TransportError`s, and emits
  telemetry for successes, errors, rate limits and retries.

  Host applications can provide their own implementation by passing it as Req's
  `:retry` option, e.g.:

      config :bexio_api_client, :req_options,
        retry: &MyApp.RetryPolicy.retry/2

  Note that the token endpoint never uses this policy — refresh retry/backoff
  policy belongs to `BexioApiClient.Req.AccessTokenRefresher`.
  """

  @callback retry(Req.Request.t(), Req.Response.t() | Exception.t()) ::
              boolean() | {:delay, non_neg_integer()}
end
