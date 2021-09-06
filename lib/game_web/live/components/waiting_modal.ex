defmodule GameWeb.Live.Component.WaitingModal do
  use Phoenix.LiveComponent

  alias GameWeb.Live.Component.StarRating

  @impl true
  def render(assigns) do
    ~H"""
      <div class="fixed z-10 inset-0 overflow-y-auto">
        <div class="flex justify-center min-h-screen px-4 py-4 text-center items-center sm:p-0">
          <div class="fixed inset-0 transition-opacity">
            <div class="absolute inset-0 opacity-75"></div>
          </div>

          <!-- This element is to trick the browser into centering the modal contents. -->
          <span class="hidden sm:inline-block sm:align-middle sm:h-screen"></span>​
          <div class="overflow-visible border-4 border-indigo-600 border-opacity-75 inline-block align-bottom bg-white rounded-lg px-12 pt-5 pb-4 text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-sm sm:w-full sm:p-6" role="dialog" aria-modal="true" aria-labelledby="modal-headline">
            <div class="hidden sm:block absolute top-0 right-0 pt-2 pr-2">
            </div>

            <div class="block absolute m-auto overflowing-logo">
              <img width="195" height="195" src="/images/logo.png">
            </div>
            <div class="py-8"></div>

            <div>
              <div class="mt-3 text-center sm:mt-5">
                <!-- This is the spot to render_block -->
                <p class="mt-2 flex items-center justify-center text-sm text-gray-800 opacity-70">
                  <svg class="mr-1 h-5 w-5 text-yellow-500 text-opacity-75" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path d="M11 3a1 1 0 10-2 0v1a1 1 0 102 0V3zM15.657 5.757a1 1 0 00-1.414-1.414l-.707.707a1 1 0 001.414 1.414l.707-.707zM18 10a1 1 0 01-1 1h-1a1 1 0 110-2h1a1 1 0 011 1zM5.05 6.464A1 1 0 106.464 5.05l-.707-.707a1 1 0 00-1.414 1.414l.707.707zM5 10a1 1 0 01-1 1H3a1 1 0 110-2h1a1 1 0 011 1zM8 16v-1h4v1a2 2 0 11-4 0zM12 14c.015-.34.208-.646.477-.859a4 4 0 10-4.954 0c.27.213.462.519.476.859h4.002z"></path></svg>
                  Best with 3-8 players
                </p>
                <%= for player <- @playerz do %>
                  <div class="pt-2 pb-2 flex items-center justify-between flex-wrap sm:flex-nowrap">
                    <div class="ml-4 mt-2 flex flex-grow">
                      <div class="flex-shrink-0">
                        <div class="flex">
                          <span class="inline-block">
                            <img class="h-14 w-14 rounded-full" src={"/images/avatars/#{player.icon}.png"}>
                          </span>
                        </div>
                      </div>
                      <div class="ml-5 w-0 flex-1">
                        <dl>
                          <dt class="flex text-normal leading-5 font-medium text-gray-500 sm:text-lg md:text-xl">
                            <%= live_component StarRating, player: player %>
                          </dt>
                          <dd class="flex items-baseline pt-2" style="width: 150%;">
                            <div class="flex capitalize text-sm leading-5 font-medium text-gray-900 sm:text-normal md:text-lg">
                              <%= player.username %>
                            </div>
                          </dd>
                        </dl>
                      </div>
                    </div>
                  </div>
                <% end %>
                <%= if !@player_is_active do %>
                  <h4 class="pt-4 inline-block text-normal leading-6 font-medium text-gray-600">
                    waiting for the host to begin
                  </h4>
                  <span class="waiting transition duration-150 ease-in-out text-lg font-medium">
                    <span>.</span><span>.</span><span>.</span>
                  </span>
                <% end %>

              </div>
            </div>
            <div class="mt-5 sm:mt-6">
              <span class="flex w-full rounded-md shadow-sm">
                <%= if @active_player do %>
                  <button phx-click={@click} type="button" class="inline-flex justify-center w-full rounded-md border border-transparent px-4 py-2 bg-indigo-600 text-large leading-6 font-medium text-white shadow-sm hover:bg-indigo-500 focus:outline-none focus:border-indigo-700 focus:shadow-outline-indigo transition ease-in-out duration-150 sm:text-large sm:leading-5"><%= @label %></button>
                <% else %>
                  <div class="w-full rounded-md shadow">
                    <a href="/" class="bg-gray-100 hover:bg-gray-200 hover:bg-opacity-75 inline-flex justify-center w-full rounded-md border border-transparent px-4 py-2 text-large leading-6 font-medium text-gray-500 shadow-sm focus:outline-none focus:border-gray-500 focus:shadow-outline-gray hover:text-gray-600 transition ease-in-out duration-150 sm:text-large sm:leading-5">
                      LEAVE GAME
                    </a>
                  </div>
                <% end %>
              </span>
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
end
