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

## Refresh token rotation (important)

Bexio's token endpoint (a Keycloak realm) rotates refresh tokens: every token
response may contain a NEW `refresh_token`, and the previously used one becomes
invalid. Reusing a stale token can get your OAuth client **blacklisted** by
Bexio (`403` with `{"reason": "blacklisted", "status": "blocked"}`).

When you use the OAuth client (`BexioApiClient.new/3,4`), the access token
refresher handles this for you and propagates the rotated token. You still MUST
persist the rotated refresh token, otherwise the refresh flow breaks after one
rotation. Either:

```elixir
req =
  BexioApiClient.new(client_id, client_secret, refresh_token,
    on_refresh_token_rotated: {MyApp.Tokens, :store, [user_id]}
  )
```

The MFA is called as `MyApp.Tokens.store(user_id, client_id, new_refresh_token)`,
or hook the `[:bexio_api_client, :refresh_token_rotated]` telemetry event
(metadata contains only short token hashes, never the token values).

Refresh failures are classified and backed off automatically:

- `400`/`401` `invalid_grant` and `403` (blacklisted) responses are **permanent**:
  requests fail fast with `BexioApiClient.RefreshError` and the token endpoint is
  not hit again. Call `BexioApiClient.Req.AccessTokenRefresher.clear_refresh_failure/1`
  once you have persisted a new refresh token.
- `429` responses back off exponentially (cap 60s).
- transport errors and other statuses back off exponentially with jitter (cap
  30s); after 5 consecutive failures, requests fail fast for 5 minutes.

Do not wrap client requests in your own retry loops: transient token failures
are already backed off, and permanent ones will never succeed — retrying them
is exactly what gets an OAuth client blacklisted.

Concurrent requests on the same token are refreshed once (single flight); the
access token cache lives in the `:bexio_api_client_access_tokens` ETS table
keyed by `{client_id, refresh_token}`.

`BexioApiClient.access_token/3` returns the full token map
(`%{access_token: ..., expires_in: ..., refresh_token: ..., id_token: ..., scope: ..., token_type: ...}`)
— persist the returned `refresh_token` when it is not `nil`. Every non-success
response returns `{:error, {:unexpected_response, status, body}}` and logs the
full `Req.Response` for diagnostics.

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

#### `[:bexio_api_client, :refresh_token_rotated]`

Emitted when the token endpoint returned a new refresh token (rotation). The host
application MUST persist the rotated token (see [Refresh token rotation](#refresh-token-rotation-important)).

- **Measurements**: `%{count: 1}`
- **Metadata**: `%{client_id: binary(), old_refresh_token_hash: binary(), new_refresh_token_hash: binary()}` - short SHA-256 prefixes of the tokens, never the token values

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
