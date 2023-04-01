defmodule BexioApiClient.MixProject do
  use Mix.Project

  def project do
    [
      app: :bexio_api_client,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # API Client, for now fixed to tesla, may change later if needed
      {:tesla, "~> 1.4"},

      # The API is completely in JSON, so need this dependency too
      {:jason, ">= 1.0.0"},

      # Typespecs everywhere...
      {:dialyxir, "~> 1.2", only: [:dev], runtime: false},

      # Not including the dependency because I don't care... as long as Europe/Zurich is supported...
      {:tz, "~> 0.26.1", only: [:test]}
    ]
  end
end
