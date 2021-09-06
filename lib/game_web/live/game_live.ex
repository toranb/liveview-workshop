defmodule GameWeb.GameLive do
  use Phoenix.LiveView

  alias GameWeb.Presence
  alias Phoenix.Socket.Broadcast
  alias GameWeb.Live.Component.WaitingModal
  alias GameWeb.Live.Component.StarRating
  alias GameWeb.Live.Component.OrderIcon
  alias GameWeb.Live.Component.Finished
  alias GameWeb.Router.Helpers, as: Routes

  @impl true
  def render(assigns) do
    ~H"""
      <main>
        <div id="app">
          <div class="z-20 flex justify-center" style="height: 100px;">
            <div class="game-hud w-full max-w-xl px-4 bg-white rounded-b-lg shadow-lg border-4 border-t-0 border-purple-400 border-opacity-75">
              <div class="w-full flex items-center justify-between p-3 px-8 space-x-3">
                <div class="flex-1">
                  <div class="flex items-center space-x-3">
                    <h3 class="capitalize text-gray-900 text-2xl leading-5 font-medium"><%= current_player(assigns) %></h3>
                  </div>

                  <div class="mt-1 overflow-hidden text-xl">
                    <%= live_component StarRating, player: @player %>
                  </div>

                </div>
                <div class="flex">
                  <%= if is_active_and_started(assigns) do %>
                    <span class="inline-block relative">
                      <button phx-click="skip_turn" type="button" id="skip" class="pass-animation h-16 w-16 rounded-full bg-green-500 border-4 border-solid border-green-600 border-opacity-7 leading-9">
                        <svg class="inline w-6 h-6 text-white -mt-1" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11.933 12.8a1 1 0 000-1.6L6.6 7.2A1 1 0 005 8v8a1 1 0 001.6.8l5.333-4zM19.933 12.8a1 1 0 000-1.6l-5.333-4A1 1 0 0013 8v8a1 1 0 001.6.8l5.333-4z"></path></svg>
                      </button>
                    </span>
                  <% else %>
                    <span class="inline-block relative">
                      <button type="button" phx-click="settings" class="block">
                        <img class="h-16 w-16 rounded-full" src={user_icon(@socket, assigns)}>
                      </button>
                    </span>
                  <% end %>
                </div>
              </div>
            </div>
          </div>
          <div class="flex justify-center text-center" style="height: calc(100vh - 205px);max-height: 220px;">
            <div class="w-full cards max-w-3xl">
              <div class="mt-2 mb-4 w-full h-full flex justify-center">
                <div class="flex w-full h-full justify-center">
                  <%= for c <- assigns.current do %>
                    <div class={"flex flex-col -mr-24 card flipped last:mr-0 px-4 md:px-2 lg:px-0 #{if player_is_active(assigns, current_player_struct(assigns)), do: "animateplay-#{c.name}"}"} style="max-width:unset;flex:unset;width:155px;">
                      <div class="relative">
                        <div class="h-full p-1 back bg-white rounded shadow-xl cursor-pointer"><img src="/images/card.jpg" /></div>
                        <div class="h-full p-1 front bg-white rounded shadow-xl absolute inset-0 cursor-pointer"><img src={c.image} /></div>
                      </div>
                    </div>
                  <% end %>
                </div>

              <%= if no_current(assigns) do %>
                <div class="flex flex-col card current opacity-70 absolute px-4 md:px-2 lg:px-0" style="max-width:unset;flex:unset;width:155px;">
                  <div class="relative">
                    <div class="h-full p-1 back bg-white rounded shadow-xl cursor-pointer"><img src="/images/card.jpg" /></div>
                    <div class="h-full p-1 front bg-white rounded shadow-xl absolute inset-0 cursor-pointer"></div>
                  </div>
                </div>
              <% end %>

              <%= if !waiting(assigns) do %>
                <div class="flex flex-col items-center absolute right-0">
                <%= for player <- assigns.playerz do %>
                  <div class="mb-1 last:mb-0 flex items-center justify-between flex-wrap">
                    <div class="flex flex-grow">
                      <div class="flex-shrink-0">
                        <div class="flex">
                          <span class="inline-block relative h-8 md:h-8 lg:h-10 xl:h-12">
                            <button type="button" phx-click="details" phx-value-player-id={player.user_id}>
                              <img class="h-8 w-8 md:h-8 md:w-8 lg:h-10 lg:w-10 xl:h-12 xl:w-12 rounded-full" src={"/images/avatars/#{player.icon}.png"}>
                              <span class={"#{if player_is_active(assigns, player), do: "bg-green-400 ", else: "bg-gray-500 "} absolute bottom-0 block h-2 w-2 md:h-2 md:w-2 lg:h-3 lg:w-3 xl:h-3.5 xl:w-3.5 rounded-full text-white shadow-solid"}>
                                <%= live_component OrderIcon, classNames: "h-2 w-2 md:h-2 md:w-2 lg:h-3 lg:w-3 xl:h-3.5 xl:w-3.5" %>
                              </span>
                            </button>
                          </span>
                        </div>
                      </div>
                    </div>
                  </div>
                <% end %>
                </div>
              <% end %>

              </div>
              <div class="my-2 w-full flex justify-center">
                <%= for card <- rows(assigns) do %>
                  <div class={"flex flex-col -mr-6 card flipped last:mr-0 #{clazz(card)}"} phx-click="stage" phx-value-flip-id={card.id}>
                    <div class="relative">
                      <button class="h-full p-1 back bg-white rounded shadow-xl cursor-pointer"><img src="/images/card.jpg" /></button>
                      <button class="h-full p-1 front bg-white rounded shadow-xl absolute inset-0 cursor-pointer"><img src={card.image} /></button>
                    </div>
                  </div>
                <% end %>
                <%= if no_hand(assigns) do %>
                  <%= live_component Finished, order: assigns.order, ranks: assigns.ranks, current_player: current_player_struct(assigns) %>
                <% end %>
              </div>
            </div>
          </div>
          <%= if splash(assigns) do %>
            <div class="splash h-screen z-10">
              <div class="content">
                <%= cond do %>
                  <% winner(assigns) -> %>
                    <!-- use a modal component here -->
                  <% settings_modal(assigns) -> %>
                    <!-- use a modal component here -->
                  <% waiting(assigns) -> %>
                    <%= live_component WaitingModal, label: "START GAME", click: "begingame", active_player: is_active(assigns), playerz: assigns.playerz, player_is_active: player_is_active(assigns, current_player_struct(assigns)) %>
                  <% details(assigns) -> %>
                    <!-- use a modal component here -->
                  <% true -> %>
                    <!-- nothing -->
                <% end %>
              </div>
            </div>
          <% end %>
        </div>
      </main>
    """
  end

  @impl true
  def mount(_params, %{"game_name" => game_name, "session_uuid" => session_uuid} = session, socket) do
    socket =
      assign_new(socket, :player, fn ->
        get_player(session)
      end)

    if connected?(socket), do: subscribe(game_name, session_uuid)
    state = rehydrate(game_name, session_uuid)

    {:ok,
     set_state(socket, state, %{
       session_uuid: session_uuid,
       game_name: game_name,
       detail_id: nil,
       settings_modal: nil
     })}
  end

  @impl true
  def handle_event("close", _value, socket) do
    %{game_name: game_name, winner: winner} = socket.assigns

    if is_nil(winner) do
      socket =
        socket
        |> assign(detail_id: nil)
        |> assign(settings_modal: nil)

      {:noreply, socket}
    else
      with_session(game_name, socket, fn game_name ->
        Game.Session.restart(game_name)
      end)
    end
  end

  @impl true
  def handle_event("settings", _value, socket) do
    socket = socket |> assign(settings_modal: true)

    {:noreply, socket}
  end

  @impl true
  def handle_event("details", %{"player-id" => player_user_id}, socket) do
    socket = socket |> assign(detail_id: player_user_id)

    {:noreply, socket}
  end

  @impl true
  def handle_event("continue", _value, socket) do
    socket =
      socket
      |> assign(detail_id: nil)
      |> assign(settings_modal: nil)

    {:noreply, socket}
  end

  @impl true
  def handle_event("begingame", _value, %{assigns: %{game_name: game_name}} = socket) do
    with_session(game_name, socket, fn game_name ->
      Game.Session.started(game_name)
    end)
  end

  @impl true
  def handle_event("restart", _value, %{assigns: %{game_name: game_name}} = socket) do
    with_session(game_name, socket, fn game_name ->
      Game.Session.restart(game_name)
    end)
  end

  @impl true
  def handle_event("skip_turn", value, %{assigns: %{game_name: game_name, player: %Game.Player{user_id: user_id}}} = socket) do
    with_session(game_name, socket, fn game_name ->
      Game.Session.skip_turn(game_name, user_id)
    end)
  end

  @impl true
  def handle_event("stage", %{"flip-id" => flip_id}, socket) do
    %{
      :game_name => game_name,
      :player => %Game.Player{user_id: user_id},
      :player_hands => player_hands
    } = socket.assigns

    if is_active(socket.assigns) do
      cards =
        case Enum.find(player_hands, fn {k, _} -> k == user_id end) do
          nil -> []
          {_, hand} -> hand
        end

      clicked_card = Enum.find(cards, fn card -> card.id == flip_id end)

      with_session(game_name, socket, fn game_name ->
        if clicked_card.staged == true do
          Game.Session.play(game_name, user_id)
        else
          Game.Session.stage(game_name, flip_id, user_id)
        end
      end)
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("update_icon", value, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_info({:update_player, user_id, icon}, %{assigns: %{playerz: playerz}} = socket) do
    new_playerz = playerz |> Enum.map(&update_player_icon(&1, user_id, icon))
    socket = socket |> assign(playerz: new_playerz)

    {:noreply, socket}
  end

  @impl true
  def handle_info({:summary, game}, socket) do
    {:noreply, set_state(socket, game, socket.assigns)}
  end

  @impl true
  def handle_info({:join, %{:game_name => game_name}}, socket) do
    with_session(game_name, socket, fn game_name ->
      Game.Session.game_state(game_name)
    end)
  end

  @impl true
  def handle_info(%Broadcast{event: "presence_diff"}, socket) do
    %{:game_name => game_name} = socket.assigns

    users = Presence.list("users:#{game_name}")
    socket = socket |> assign(users: users)

    {:noreply, socket}
  end

  @impl true
  def terminate({:shutdown, :closed}, socket) do
    %{:game_name => game_name, :session_uuid => session_uuid} = socket.assigns

    if Game.SessionCache.find_game(game_name) do
      game = Game.Session.leave(game_name, session_uuid)
      Phoenix.PubSub.broadcast_from(Game.PubSub, self(), "game:#{game_name}", {:summary, game})
    end

    :ok
  end

  @impl true
  def terminate(:shutdown, _socket) do
    :ok
  end

  def subscribe(game_name, session_uuid) do
    Phoenix.PubSub.subscribe(Game.PubSub, "users:#{game_name}")
    Phoenix.PubSub.subscribe(Game.PubSub, "player:#{session_uuid}")
    Phoenix.PubSub.subscribe(Game.PubSub, "game:#{game_name}")

    Presence.track(self(), "users:#{game_name}", session_uuid, %{username: session_uuid})

    Phoenix.PubSub.broadcast_from(Game.PubSub, self(), "game:#{game_name}", {:join, %{game_name: game_name}})
  end

  def no_hand(%{started_at: started_at} = assigns) do
    if is_nil(started_at) do
      false
    else
      rows(assigns)
      |> Enum.reject(&(&1.played == true))
      |> Enum.empty?()
    end
  end

  def rows(%{player_hands: player_hands, player: %Game.Player{user_id: user_id}}) do
    cards =
      case Enum.find(player_hands, fn {k, _} -> k == user_id end) do
        nil -> []
        {_, hand} -> hand
      end

    Enum.map(cards, &Map.from_struct(&1))
  end

  def set_state(socket, nil, _) do
    socket |> redirect(to: Routes.page_path(socket, :index))
  end

  def set_state(socket, state, %{
        session_uuid: session_uuid,
        game_name: game_name,
        detail_id: detail_id,
        settings_modal: settings_modal
      }) do
    %Game.Engine{
      ranks: ranks,
      order: order,
      current: current,
      winner: winner,
      player_hands: player_hands,
      started_at: started_at,
      active_player_id: active_player_id,
      cards: cards,
      scores: scores,
      players: players
    } = state

    users = Presence.list("users:#{game_name}")

    playerz =
      players
      |> Enum.reduce([], fn player, acc ->
        all_users = users |> Map.keys()

        if "#{player}" in all_users do
          acc ++ [player]
        else
          acc
        end
      end)
      |> Enum.map(fn user_id ->
        get_player(user_id)
      end)

    assign(socket,
      ranks: ranks,
      order: order,
      current: current,
      started_at: started_at,
      session_uuid: session_uuid,
      detail_id: detail_id,
      settings_modal: settings_modal,
      game_name: game_name,
      cards: cards,
      scores: scores,
      active_player_id: active_player_id,
      users: users,
      winner: winner,
      playerz: playerz,
      player_hands: player_hands
    )
  end

  def clazz(%{staged: staged, played: played}) do
    case played == true do
      true ->
        "hidden"

      false ->
        case staged == true do
          true -> "staged"
          false -> ""
        end
    end
  end

  def splash(assigns) do
    cond do
      winner(assigns) ->
        true

      waiting(assigns) ->
        true

      details(assigns) ->
        true

      settings_modal(assigns) ->
        true

      true ->
        false
    end
  end

  def user_icon(socket, %{player: %Game.Player{icon: icon}}) do
    Routes.static_path(socket, "/images/avatars/#{icon}.png")
  end

  def is_active_and_started(%{started_at: started_at} = assigns) do
    if is_nil(started_at) do
      false
    else
      is_active(assigns)
    end
  end

  def is_active(%{player: nil}), do: false

  def is_active(%{active_player_id: active_player_id, player: %Game.Player{user_id: user_id}}),
    do: active_player_id === user_id

  def is_active_player(%{active_player_id: active_player_id}, %Game.Player{user_id: user_id}) do
    active_player_id == user_id
  end

  def current_player(%{player: nil}), do: ""
  def current_player(%{player: %Game.Player{username: username}}), do: username
  def current_player_struct(%{player: nil}), do: nil
  def current_player_struct(%{player: %Game.Player{} = player}), do: player

  def winner(%{winner: winner, playerz: playerz}) do
    player = Enum.find(playerz, &(&1.user_id == winner))
    name = (player && player.username) || winner

    cond do
      name == winner and winner != nil -> name
      name == nil -> nil
      true -> name
    end
  end

  def no_current(%{current: current}) do
    if Enum.count(current) == 0 do
      true
    else
      false
    end
  end

  defp waiting(%{started_at: started_at}) do
    if is_nil(started_at) do
      true
    else
      false
    end
  end

  defp settings_modal(%{settings_modal: settings_modal}) do
    if is_nil(settings_modal) do
      nil
    else
      settings_modal
    end
  end

  defp details(%{detail_id: detail_id}) do
    if is_nil(detail_id) do
      nil
    else
      get_player(detail_id)
    end
  end

  defp player_is_active(%{active_player_id: active_player_id}, %Game.Player{user_id: user_id}) do
    active_player_id == user_id
  end

  def rehydrate(game_name, session_uuid) do
    case Game.SessionCache.find_game(game_name) do
      nil ->
        Game.SessionSupervisor.start_game(game_name)
        Game.Session.join(game_name, session_uuid)

      {_id} ->
        Game.Session.join(game_name, session_uuid)
    end
  end

  def with_session(game_name, socket, func) do
    case Game.SessionCache.find_game(game_name) do
      nil ->
        raise("no game found with name #{inspect(game_name)}")

      {_} ->
        state = func.(game_name)
        Phoenix.PubSub.broadcast_from(Game.PubSub, self(), "game:#{game_name}", {:summary, state})

        {:noreply, set_state(socket, state, socket.assigns)}
    end
  end

  def get_player(%{"session_uuid" => session_uuid}) when is_binary(session_uuid) do
    {_user_id, username, icon} = Game.PlayerCache.find_player(session_uuid)
    %Game.Player{user_id: session_uuid, username: username, icon: icon}
  end

  def get_player(session_uuid) when is_binary(session_uuid) do
    {_user_id, username, icon} = Game.PlayerCache.find_player(session_uuid)
    %Game.Player{user_id: session_uuid, username: username, icon: icon}
  end

  def update_player_icon(player, user_id, icon) do
    if player.user_id == user_id do
      %{player | icon: icon}
    else
      player
    end
  end
end
