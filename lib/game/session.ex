defmodule Game.Session do
  use GenServer

  @timeout :timer.minutes(90)

  def start_link(name, random) do
    GenServer.start_link(__MODULE__, {:ok, name, random}, name: via(name))
  end

  defp via(name), do: Game.Registry.via(name)

  @impl GenServer
  def init({:ok, name, random}) do
    playing_cards = ["jack", "queen", "king"]
    state = Game.Engine.new(name, playing_cards, random)

    {:ok, state, @timeout}
  end

  def session_pid(name) do
    name
    |> via()
    |> GenServer.whereis()
  end

  def game_state(name) do
    GenServer.call(via(name), {:game_state})
  end

  def join(name, player_id) do
    GenServer.call(via(name), {:join, player_id})
  end

  def started(name) do
    GenServer.call(via(name), {:started})
  end

  def leave(name, player_id) do
    GenServer.call(via(name), {:leave, player_id})
  end

  def stage(name, id, player_id) do
    GenServer.call(via(name), {:stage, id, player_id})
  end

  def play(name, player_id) do
    GenServer.call(via(name), {:play, player_id})
  end

  def skip_turn(name, player_id) do
    GenServer.call(via(name), {:skip_turn, player_id})
  end

  def restart(name) do
    GenServer.call(via(name), {:restart})
  end

  @impl GenServer
  def handle_call({:join, player_id}, _from, state) do
    new_state =
      case Game.Engine.join(state, player_id) do
        {:ok, new_game_state} -> new_game_state
        _ -> nil
      end

    {:reply, new_state, new_state, @timeout}
  end

  @impl GenServer
  def handle_call({:started}, _from, state) do
    new_state = Game.Engine.started(state, true)

    {:reply, new_state, new_state, @timeout}
  end

  @impl GenServer
  def handle_call({:leave, player_id}, _from, state) do
    new_state = Game.Engine.leave(state, player_id)

    {:reply, new_state, new_state, @timeout}
  end

  @impl GenServer
  def handle_call({:stage, id, player_id}, _from, state) do
    new_state = Game.Engine.stage(state, id, player_id)

    {:reply, new_state, new_state, @timeout}
  end

  @impl GenServer
  def handle_call({:play, player_id}, _from, state) do
    new_state = Game.Engine.play(state, player_id)

    {:reply, new_state, new_state, @timeout}
  end

  @impl GenServer
  def handle_call({:skip_turn, player_id}, _from, state) do
    new_state = Game.Engine.skip_turn(state, player_id)

    {:reply, new_state, new_state, @timeout}
  end

  @impl GenServer
  def handle_call({:restart}, _from, state) do
    new_state = Game.Engine.restart(state)

    {:reply, new_state, new_state, @timeout}
  end

  @impl GenServer
  def handle_call({:game_state}, _from, state) do
    {:reply, state, state, @timeout}
  end
end
