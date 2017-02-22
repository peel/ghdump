defmodule Ghdump.Mixfile do
  use Mix.Project

  def project do
    [app: :ghdump,
     version: "0.1.0",
     elixir: "~> 1.4",
     escript: [main_module: Ghdump.CLI],
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger, :tentacat]]
  end

  defp deps do
    [
      {:tentacat, "~> 0.6.1"},
      {:httpoison, "~> 0.11.0"},
      {:zipflow, "~> 0.0.1"},
      {:flow, "~> 0.11"}
    ]
  end
end
