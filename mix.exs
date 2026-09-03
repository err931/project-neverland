# SPDX-FileCopyrightText: 2026 Minoru Maekawa
#
# SPDX-License-Identifier: FSL-1.1-ALv2

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
      {:ecto_sql, "~> 3.14"},
      {:postgrex, ">= 0.0.0"},
      {:nebulex, "~> 3.0"},
      {:nebulex_local, "~> 3.0"},
      {:decorator, "~> 1.4"},
      {:bandit, "~> 1.12"},
      {:req, "~> 0.7.0"},
      {:jose, "~> 1.11"},
      {:hammer, "~> 7.4"},
      {:jason, "~> 1.4"},
      {:telemetry, "~> 1.4"},
      {:rustler, "~> 0.38", runtime: false},
      {:boundary, "~> 0.10", runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:ex_slop, "~> 0.4", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false}
    ]
  end
end
