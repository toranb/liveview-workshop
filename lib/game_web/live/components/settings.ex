defmodule GameWeb.Live.Component.Settings do
  use Phoenix.LiveComponent

  alias GameWeb.Router.Helpers, as: Routes

  @impl true
  def render(assigns) do
    ~H"""
      <div class="flex flex-wrap">
        <%= for icon <- @choices do %>
          <div id={icon.id} draggable="true" phx-hook="DragIcon">
            <button id={icon.id} class="block" type="button">
              <img class="h-16 w-16 rounded-full" src={icon.src}>
            </button>
          </div>
        <% end %>
      </div>
    """
  end

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(%{id: user_id}, socket) do
    choices = socket |> get_icons()

    {:ok, assign(socket, id: user_id, choices: choices)}
  end

  def get_icons(socket) do
    Game.Generator.numbers()
    |> Enum.map(fn icon ->
      %{id: icon, src: Routes.static_path(socket, "/images/avatars/#{icon}.png")}
    end)
  end
end
