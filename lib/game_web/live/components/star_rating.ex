defmodule GameWeb.Live.Component.StarRating do
  use Phoenix.LiveComponent

  @impl true
  def render(assigns) do
    ~H"""
      <span class="flex-shrink-0 inline-block py-0.5 leading-4 font-medium text-purple-400">
        <%= cond do %>
          <% five(@player) -> %>★★★★★
          <% four(@player) -> %>★★★★☆
          <% three(@player) -> %>★★★☆☆
          <% two(@player) -> %>★★☆☆☆
          <% true -> %>★☆☆☆☆
        <% end %>
      </span>
    """
  end

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(%{player: player}, socket) do
    {:ok, assign(socket, player: player)}
  end

  def five(nil), do: false

  def five(player) do
    %Game.Player{wins: wins, plays: plays} = player

    if plays > 60 && wins > 20 do
      true
    else
      false
    end
  end

  def four(nil), do: false

  def four(player) do
    %Game.Player{wins: wins, plays: plays} = player

    if plays > 40 && wins > 10 do
      true
    else
      false
    end
  end

  def three(nil), do: false

  def three(player) do
    %Game.Player{wins: wins, plays: plays} = player

    if plays > 20 && wins > 2 do
      true
    else
      false
    end
  end

  def two(nil), do: false

  def two(player) do
    %Game.Player{wins: wins, plays: plays} = player

    if plays > 10 && wins > 1 do
      true
    else
      false
    end
  end
end
