defmodule Game.SessionSupervisor do
  use DynamicSupervisor

  def start_link(_args) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    # children = [
    #   {Game.Session, []}
    # ]

    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_game(game_name, random \\ Game.Random) do
    spec = %{id: Game.Session, start: {Game.Session, :start_link, [game_name, random]}}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end
end
