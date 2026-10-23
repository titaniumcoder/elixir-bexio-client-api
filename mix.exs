defmodule BexioApiClient.MixProject do
  use Mix.Project

  def project do
    [
      app: :bexio_api_client,
      version: "2.0.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description(),
      dialyzer: [
        plt_add_deps: :apps_direct,
        flags: ["-Wunmatched_returns", :error_handling, :underspecs]
      ]
    ]
  end

  defp description do
    """
    Bexio API Client for accessing the API described at https://docs.bexio.com.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE.md", "CHANGELOG.md"],
      maintainers: ["Rico Metzger"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/titaniumcoder/elixir-bexio-client-api",
        "Changelog" => "https://github.com/titaniumcoder/elixir-bexio-client-api/blob/main/CHANGELOG.md",
        "OpenAPI spec" => "https://github.com/titaniumcoder/elixir-bexio-client-api/blob/main/docs/bexio-openapi.yaml",
        "Docs" => "https://hexdocs.pm/bexio_api_client/",
        "Bexio API Docs" => "https://docs.bexio.com"
      }
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
      # API Client, for now focusing on req
      {:req, "~> 0.7"},

      # The API is completely in JSON
      {:jason, ">= 1.0.0"},

      # Typespecs everywhere...
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},

      # Decimal for the money amounts
      {:decimal, "~> 3.0"},

      # Credo support
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},

      # Telemetry for metrics
      {:telemetry, "~> 1.0"},

      # Create documentation
      {:ex_doc, "~> 0.40", only: :dev},
      {:plug, "~> 1.0", only: :test}
    ]
  end
end
