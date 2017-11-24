defmodule ExOpenpay.Mixfile do
  use Mix.Project

  def project do
    [app: :openpay,
     version: "0.1.0",
     description: description(),
     package: package(),
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [ applications: [:httpotion] ]
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:httpoison, ">= 0.0.0" },
      {:poison, ">= 0.0.0", optional: true},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:earmark, ">= 0.0.0", only: :dev},
      {:excoveralls, ">= 0.0.0", only: :test},
      {:exvcr, ">= 0.0.0", only: :test},
      {:mock, ">= 0.0.0", only: :test},
      {:inch_ex, ">= 0.0.0", only: [:dev, :test]}
    ]
  end

  defp description do
    """
    A OpenPay Library for Elixir.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Yamil Díaz Aguirre"],
      licenses: ["New BSD"],
      links: %{
        "GitHub" => "https://github.com/grvty-labs/openpay",
        "Docs" => "https://hexdocs.pm/openpay"
      }
    ]
  end

end
