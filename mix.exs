defmodule BexioApiClient.MixProject do
  use Mix.Project

  def project do
    [
      app: :bexio_api_client,
      version: "0.4.1",
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
        "GitHub" => "https://github.com/rmse-ch/elixir-bexio-client-api",
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
      # API Client
      {:req, "~> 0.4.11", optional: true},

      # The API is completely in JSON
      {:jason, ">= 1.0.0"},

      # Typespecs everywhere...
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},

      # Decimal for the money amounts
      {:decimal, "~> 2.0"},

      # Credo support
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},

      # Create documentation
      {:ex_doc, "~> 0.29.4", only: :dev},
      {:earmark, "~> 1.4", only: :dev},
      {:plug, "~> 1.0", only: :test}
    ]
  end
end
