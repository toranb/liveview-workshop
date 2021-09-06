defmodule Game.PlayerCache do
  use Supervisor

  @table :players_table

  def find_player(user_id) do
    case :ets.lookup(@table, user_id) do
      [{user_id, username, icon}] ->
        {user_id, username, icon}

      [] ->
        icon = Game.Generator.icon()
        username = Game.Generator.username()
        :ets.insert(@table, {user_id, username, icon})
        {user_id, username, icon}
    end
  end

  def update_player(user_id, icon) do
    case :ets.lookup(@table, user_id) do
      [{_, username, _}] ->
        :ets.insert(@table, {user_id, username, icon})

      [] ->
        :ok
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
