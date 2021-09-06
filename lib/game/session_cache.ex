defmodule Game.SessionCache do
  use Supervisor

  @table :game_sessions_table

  def find_game(game_name) do
    case :ets.lookup(@table, game_name) do
      [{game_name}] ->
        {game_name}

      [] ->
        fallback(game_name)
    end
  end

  def fallback(game_name) do
    case Game.Session.session_pid(game_name) do
      pid when is_pid(pid) ->
        :ets.insert(@table, {game_name})
        {game_name}

      nil ->
        nil
    end
  end

  def child_spec(opts) do
    name = opts[:name] || raise ArgumentError, ":name is required"

    %{
      id: name,
      type: :supervisor,
      start: {__MODULE__, :start_link, [opts]}
    }
  end

  def start_link(args) do
    name = args[:name]
    Supervisor.start_link(__MODULE__, args, name: name)
  end

  def init(args) do
    name = Keyword.get(args, :name)

    ^name = :ets.new(name, [:set, :named_table, :public, read_concurrency: true])

    Supervisor.init([], strategy: :one_for_one)
  end
end
