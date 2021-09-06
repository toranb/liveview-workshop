defmodule GameWeb.Live.Component.Finished do
  use Phoenix.LiveComponent

  @impl true
  def render(assigns) do
    ~H"""
      <div class="max-w-xl w-full py-4 mt-2.5">
        <div class="">
          <div class="border-2 border-gray-50 border-opacity-75 relative bg-white shadow rounded">
            <div class="px-4">
              <div class="divide-y divide-gray-200">
                <div class="w-full h-44 pt-4 pb-6 flex items-center justify-between flex-wrap sm:flex-nowrap">
                  <div class="w-full text-center sm:flex sm:flex-col sm:align-center">
                    <h1 class="inline-flex flex-wrap items-center justify-center text-xl md:text-2xl leading-none font-extrabold text-gray-600 text-center">
                      <svg class="w-6 h-6 mr-1 text-red-400" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" d="M12.395 2.553a1 1 0 00-1.45-.385c-.345.23-.614.558-.822.88-.214.33-.403.713-.57 1.116-.334.804-.614 1.768-.84 2.734a31.365 31.365 0 00-.613 3.58 2.64 2.64 0 01-.945-1.067c-.328-.68-.398-1.534-.398-2.654A1 1 0 005.05 6.05 6.981 6.981 0 003 11a7 7 0 1011.95-4.95c-.592-.591-.98-.985-1.348-1.467-.363-.476-.724-1.063-1.207-2.03zM12.12 15.12A3 3 0 017 13s.879.5 2.5.5c0-1 .5-4 1.25-4.5.5 1 .786 1.293 1.371 1.879A2.99 2.99 0 0113 13a2.99 2.99 0 01-.879 2.121z" clip-rule="evenodd"></path></svg>
                       You are the next <span class="ml-1 bg-clip-text leading-9 text-transparent bg-gradient-to-r from-teal-400 to-blue-500"> <%= next_status(@current_player, @ranks, @order) %>!</span></h1>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    """
  end

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(%{ranks: ranks, current_player: current_player, order: order}, socket) do
    {:ok, assign(socket, ranks: ranks, current_player: current_player, order: order)}
  end

  def next_status(%Game.Player{user_id: user_id}, ranks, order) do
    if Enum.count(ranks) > 0 do
      ranks
      |> Enum.with_index(1)
      |> Enum.find(fn {player_user_id, _index} ->
        if player_user_id == user_id do
          true
        else
          false
        end
      end)
      |> calculate_placement(order)
    else
      ""
    end
  end

  defp calculate_placement({_user_id, placement}, order) do
    cond do
      placement == 1 ->
        "president"

      placement == 2 ->
        "vice president"

      true ->
        total = Enum.count(order)

        indexes =
          order
          |> Enum.with_index(1)
          |> Enum.map(fn {_, index} ->
            index
          end)

        last_two =
          if total == 3 do
            [Enum.at(indexes, total - 1)]
          else
            one = indexes |> Enum.at(total - 1)
            two = indexes |> Enum.at(total - 2)
            [one, two]
          end

        if placement in last_two do
          "scum"
        else
          "nobody"
        end
    end
  end

  defp calculate_placement(nil, _order), do: ""
end
