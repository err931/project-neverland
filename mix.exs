defmodule Honeywagon.MixProject do
  use Mix.Project

  def project do
    [
      app: :honeywagon,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      compilers: [:boundary] ++ Mix.compilers(),
      test_coverage: [
        summary: [threshold: 80],
        ignore_modules: [
          Honeywagon.Native.Ruma
        ]
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Honeywagon.Application, []}
    ]
  end

  defp deps do
    [
      {:boundary, "~> 0.10", runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:ex_slop, "~> 0.4", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false}
    ]
  end
end
