import Config

config :bexio_api_client,
  req_options: [
    plug: {Req.Test, BexioApiClient}
  ]
