# Bexio API Client for Elixir

This is a simple client for the API described at [https://docs.bexio.com/](). It will support all functionality while also replacing enums with atoms and
making the structs more useful in elixir.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `bexio_api_client` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:bexio_api_client, "~> 0.1.3"}
  ]
end
```

## Requirements:

The API uses [Tesla](https://github.com/elixir-tesla/tesla) for the client access to also handle the exponential back-off required in the documentation.


## Documentation 

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/bexio_api_client>.
