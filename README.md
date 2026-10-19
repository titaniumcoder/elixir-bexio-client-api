# Bexio API Client for Elixir

This is a simple client for the API described at <https://docs.bexio.com/>. It will support all functionality while also replacing enums with atoms and
making the structs more useful in elixir.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `bexio_api_client` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:bexio_api_client, "~> 1.0"}
  ]
end
```

## Requirements:

The API uses [Req](https://github.com/wojtekmach/req/tree/v0.5.0) for the client access to also handle the exponential back-off required in the documentation.

## Refresh tokens

Bexio does not currently rotate refresh tokens — the same refresh token keeps
working — and the access token refresher does not manage rotation: it always
refreshes with the refresh token you passed to `BexioApiClient.new/3`. Should
Bexio ever enable rotation (a Keycloak realm option), token responses would
expose the new token through `BexioApiClient.access_token/3`; host applications
would have to persist it themselves.

Separately, hammering the token endpoint after failing refreshes gets your
OAuth client **blacklisted** by Bexio (`403` with
`{"reason": "blacklisted", "status": "blocked"}`, enforced per IP).

Refresh failures are classified and backed off automatically:

- `400`/`401` `invalid_grant` and `403` (blacklisted) responses are **permanent**:
  requests fail fast with `BexioApiClient.RefreshError` and the token endpoint is
  not hit again. Call `BexioApiClient.Req.AccessTokenRefresher.clear_refresh_failure/1`
  once you have a new refresh token.
- `429` responses back off exponentially (cap 60s).
- transport errors and other statuses back off exponentially with jitter (cap
  30s); after 5 consecutive failures, requests fail fast for 5 minutes.

Do not wrap client requests in your own retry loops: transient token failures
are already backed off, and permanent ones will never succeed — hammering the
token endpoint with failing refreshes is exactly what gets an OAuth client
blacklisted.

When the refresher gives up on a refresh token — immediately on a permanent
failure (`invalid_grant`, blacklisted) or after 5 consecutive transient
failures (5-minute cooldown) — it invokes the optional `:on_refresh_gave_up`
callback once:

```elixir
req =
  BexioApiClient.new(client_id, client_secret, refresh_token,
    on_refresh_gave_up: {MyApp.Auth, :refresh_gave_up, [user_id]}
  )
```

The MFA is called as `MyApp.Auth.refresh_gave_up(user_id, client_id, error_class)`
so the host application can react (re-authenticate the user, disable sync jobs,
alert) and re-enable the token afterwards with
`BexioApiClient.Req.AccessTokenRefresher.clear_refresh_failure/1`. The callback
runs synchronously while the refresh lock is held: keep it fast and do not make
requests with the same client from it.

Concurrent requests on the same token are refreshed once (single flight); the
access token cache lives in the `:bexio_api_client_access_tokens` ETS table
keyed by `{client_id, refresh_token}`.

The ETS tables are owned by the process that created them and are deleted when
that process exits. Call
`BexioApiClient.Req.AccessTokenRefresher.create_ets_table/0` once from a
long-lived process (e.g. in your application's `start/2`) so the cache and the
refresh backoff state live as long as your application. Losing the tables is
always safe — tokens are re-fetched and backoff state resets — but the cache
silently stops working until they are recreated. Concurrent creation is safe.

`BexioApiClient.access_token/3` returns the full token map
(`%{access_token: ..., expires_in: ..., refresh_token: ..., id_token: ..., scope: ..., token_type: ...}`).
Every non-success response returns `{:error, {:unexpected_response, status, body}}`
and logs the full `Req.Response` for diagnostics.

## Telemetry

The client emits telemetry events that you can use to monitor API usage, rate limiting, and performance. All events are emitted from the request/retry layer, providing comprehensive visibility into all HTTP interactions.

### Available Events

#### `[:bexio_api_client, :request, :success]`

Emitted when a request completes successfully (status 200-399).

- **Measurements**: `%{count: 1}`
- **Metadata**: `%{status: integer()}` - HTTP status code (200, 201, 301, etc.)

#### `[:bexio_api_client, :request, :error]`

Emitted when a request completes with an error (status 400+).

- **Measurements**: `%{count: 1}`
- **Metadata**: `%{status: integer()}` - HTTP status code (401, 404, etc.)

#### `[:bexio_api_client, :rate_limit, :hit]`

Emitted when a rate limit (429) response is received from the API.

- **Measurements**: `%{reset_seconds: integer()}` - The number of seconds to wait before retrying (from the `ratelimit-reset` header)
- **Metadata**: `%{has_reset_header: boolean()}` - Whether the `ratelimit-reset` header was present in the response

#### `[:bexio_api_client, :request, :retry]`

Emitted when a request will be retried due to server errors (408, 500, 502, 503, 504).

- **Measurements**: `%{count: 1}`
- **Metadata**: `%{status: integer()}` - HTTP status code that triggered the retry

#### `[:bexio_api_client, :refresh, :failed]`

Emitted when a refresh attempt failed.

- **Measurements**: `%{count: 1}`
- **Metadata**: `%{error_class: :invalid_refresh_token | :client_blacklisted | :rate_limited | :transient, failure_count: integer()}`

#### `[:bexio_api_client, :refresh, :backoff]`

Emitted when a request was rejected while a refresh backoff was active (the token
endpoint was not contacted).

- **Measurements**: `%{count: 1}`
- **Metadata**: `%{error_class: atom(), retry_in_ms: integer() | :infinity}`

### Usage Example

```elixir
# Track successful requests
:telemetry.attach(
  "bexio-success-metrics",
  [:bexio_api_client, :request, :success],
  fn _event, _measurements, metadata, _config ->
    IO.puts("Successful API call with status #{metadata.status}")
  end,
  nil
)

# Track error requests
:telemetry.attach(
  "bexio-error-metrics",
  [:bexio_api_client, :request, :error],
  fn _event, _measurements, metadata, _config ->
    Logger.warning("API error with status #{metadata.status}")
  end,
  nil
)

# Track rate limiting
:telemetry.attach(
  "bexio-rate-limit-metrics",
  [:bexio_api_client, :rate_limit, :hit],
  fn _event, measurements, metadata, _config ->
    if metadata.has_reset_header do
      IO.puts("Rate limit hit, waiting #{measurements.reset_seconds} seconds")
    else
      IO.puts("Rate limit hit without reset header, using default retry")
    end
  end,
  nil
)

# Track retry attempts
:telemetry.attach(
  "bexio-retry-metrics",
  [:bexio_api_client, :request, :retry],
  fn _event, _measurements, metadata, _config ->
    IO.puts("Request will be retried due to status #{metadata.status}")
  end,
  nil
)

# Track specific error codes like unauthorized
:telemetry.attach(
  "bexio-unauthorized-metrics",
  [:bexio_api_client, :request, :error],
  fn _event, _measurements, metadata, _config ->
    if metadata.status == 401 do
      Logger.warning("Unauthorized API request detected")
    end
  end,
  nil
)
```

You can also use libraries like [TelemetryMetrics](https://github.com/beam-telemetry/telemetry_metrics) to aggregate these events into metrics for monitoring dashboards.

## Documentation 

Documentation can be generated with [ExDoc](https://github.com/) 
and can be found at <https://hexdocs.pm/bexio_api_client>.

## Building a release

1. Update the versions in README.md, and mix.exs
2. Update the CHANGELOG.md
3. (optional, recommended) Run `mix test` and `mix dialyzer`
5. Create a tag for the new version.
6. Push it, github actions will do the release.
