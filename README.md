# Bexio API Client for Elixir

This is a simple client for the API described at <https://docs.bexio.com/>. It will support all functionality while also replacing enums with atoms and
making the structs more useful in elixir.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `bexio_api_client` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:bexio_api_client, "~> 0.9.0"}
  ]
end
```

## Requirements:

The API uses [Req](https://github.com/wojtekmach/req/tree/v0.5.0) for the client access to also handle the exponential back-off required in the documentation.

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
