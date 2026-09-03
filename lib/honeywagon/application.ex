# SPDX-FileCopyrightText: 2026 Minoru Maekawa
#
# SPDX-License-Identifier: FSL-1.1-ALv2

defmodule Honeywagon.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Honeywagon.Worker.start_link(arg)
      # {Honeywagon.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Honeywagon.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
