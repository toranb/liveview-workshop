defmodule Game.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      GameWeb.Telemetry,
      {Game.PlayerCache, name: :players_table},
      {Game.SessionCache, name: :game_sessions_table},
      {Phoenix.PubSub, name: Game.PubSub},
      {Registry, keys: :unique, name: Game.Registry},
      Game.SessionSupervisor,
      GameWeb.Presence,
      GameWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Game.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    GameWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
