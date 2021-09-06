defmodule GameWeb.Live.Component.ModalThree do
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
          <div class="border-4 border-indigo-600 border-opacity-75 inline-block align-bottom bg-white rounded-lg px-4 pt-5 pb-4 text-left overflow-hidden shadow-xl transform transition-all my-8 align-middle max-w-sm w-full sm:p-6" role="dialog" aria-modal="true" aria-labelledby="modal-headline">
            <div class="block absolute top-0 right-0 pt-2 pr-2">
              <button phx-click="close" type="button" class="text-gray-300 hover:text-gray-400 focus:outline-none focus:text-gray-400 transition ease-in-out duration-150" aria-label="Close">
                <svg class="h-6 w-6" x-description="Heroicon name: x" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                </svg>
              </button>
            </div>

            <div>
              <div class="mt-3 text-center sm:mt-5">
                <!-- This is the spot to render_block -->
                <div class="pt-2 pb-2 flex items-center justify-between flex-wrap sm:flex-nowrap">
                  <div class="ml-4 mt-2 flex flex-grow">
                    <div class="flex-shrink-0">
                      <div class="flex">
                        <span class="inline-block">
                          <img class="h-14 w-14 rounded-full" src={"/images/avatars/#{@player.icon}.png"}>
                        </span>
                      </div>
                    </div>
                    <div class="ml-5 w-0 flex-1">
                      <dl>
                        <dt class="flex text-normal leading-5 font-medium text-gray-500 truncate sm:text-lg md:text-xl">
                          <%= live_component StarRating, player: @player %>
                        </dt>
                        <dd class="flex items-baseline pt-2">
                          <div class="flex capitalize text-sm leading-5 font-medium text-gray-900 sm:text-normal md:text-lg">
                            <%= @player.username %>
                          </div>
                        </dd>
                        <dd class="text-left flex capitalize font-bold">novice</dd>
                      </dl>
                    </div>
                  </div>
                </div>
                <div class="mt-2"></div>
              </div>
            </div>
            <div class="mt-5 sm:mt-6">
              <span class="flex w-full rounded-md shadow-sm">
                <button phx-click={@click} type="button" class="inline-flex justify-center w-full rounded-md border border-transparent px-4 py-2 bg-indigo-600 text-large leading-6 font-medium text-white shadow-sm hover:bg-indigo-500 focus:outline-none focus:border-indigo-700 focus:shadow-outline-indigo transition ease-in-out duration-150 sm:text-large sm:leading-5"><%= @label %></button>
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
