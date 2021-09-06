## Installation

To build the container with docker

```
docker build -t game .
```

To run the container on macOS or Linux

```
docker run -it -p 4000:4000 -v $(pwd):/game game
```

To run the container on windows with [PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-windows-powershell?view=powershell-6#finding-powershell-in-windows-10-81-80-and-7)

```
docker run -it -p 4000:4000 -v ${PWD}:/game game
```

Install dependencies at the command line

```
mix deps.get
```

To run the web server and visit localhost:4000

```
mix phx.server
```

## Objectives

The entire workshop centers around the Phoenix LiveView page [game_live.ex](https://github.com/toranb/liveview-workshop/blob/master/lib/game_web/live/game_live.ex). This file has 3 incomplete functions that need to be implemented for the game to function correctly.

```elixir
defmodule GameWeb.GameLive do
  def handle_event("skip_turn", value, socket) do
  end

  def handle_event("stage", value, socket) do
  end

  def handle_event("update_icon", %{"icon-id" => icon}, socket) do
  end
end
```

### skip_turn

![skip](https://user-images.githubusercontent.com/147411/132255669-5606446d-1dbb-4830-9306-c642a8369fec.gif)

Start by adding a `phx-click` to the skip button and the `handle_event` code needed to drive this new game functionality.

hint: `handle_event` requires that you first get the game session by name. Once you have the game session you can then use the `skip_turn` function on the [Game.Session](https://github.com/toranb/liveview-workshop/blob/master/lib/game/session.ex) module to generate a new state for the game and return it.

### stage

![stage](https://user-images.githubusercontent.com/147411/132255679-87bcafe3-1348-4a6e-bb8d-0124c7115c59.gif)

This function is executed when the player clicks a card. Because players can play 2, 3 or 4 of a kind be sure to use the `stage` function on the [Game.Session](https://github.com/toranb/liveview-workshop/blob/master/lib/game/session.ex) module. If the clicked card is not staged, play that card instead using the `play` function on the [Game.Session](https://github.com/toranb/liveview-workshop/blob/master/lib/game/session.ex) module.

Also, be sure to only stage or play cards for the active player.

hint: to see if the player is active use the function `is_active(socket.assigns)` on the LiveView page [game_live.ex](https://github.com/toranb/liveview-workshop/blob/master/lib/game_web/live/game_live.ex).

### update_icon

![icon](https://user-images.githubusercontent.com/147411/132255703-9cb7c06c-9f02-4e02-95f8-4e866f86f27e.gif)

This function is executed only when the player opens the settings modal and clicks another icon. This feature will be completed first as a local `phx-click` event but then again as a `live_component` to show both solutions and highlight event bubbling.

## Bonus

If you complete the above and want some extra credit swap the `phx-click` that updates the player icon for drag n drop using Phoenix LiveView Hooks.
hint: the app.js file in `priv/static/js` has a hook already defined on line 157. Inside the `onEnd` function send the icon id to the server with help from [pushEvent](https://hexdocs.pm/phoenix_live_view/js-interop.html#client-server-communication) in JavaScript for client server communication.

## Debugging Tips

To print something in the Elixir source code use `IO.inspect`

```elixir
"Hello World!" |> IO.inspect()

foo_bar |> IO.inspect(label: "The foo_bar variable")
```

To hang a debugger in the Elixir source code use `IEx.pry`

```elixir
require IEx

def handle_event("skip_turn", value, socket) do
  IEx.pry
end
```

When `IEx.pry` is executed the runtime will ask you `Allow? [Yn]`

If you answer `n` the program will continue without interruption. If you answer `Y` you can ask questions of the running program. If you want to continue execution of the program type `respawn` and hit enter. To exit the REPL between test runs do `ctrl + c` twice.

For a complete list of [debugging](https://elixir-lang.org/getting-started/debugging.html) options be sure to read over the getting started guide.

## Learning Elixir

Implementing the `stage` functionality requires you cycle through a list of cards you might benefit from the [enumerables](https://elixir-lang.org/getting-started/enumerables-and-streams.html#enumerables) getting started guide. In addition, the [Enum](https://hexdocs.pm/elixir/Enum.html) module documentation provides a comprehensive look at the available functions including: [map](https://hexdocs.pm/elixir/Enum.html#map/2), [filter](https://hexdocs.pm/elixir/Enum.html#filter/2), [reject](https://hexdocs.pm/elixir/Enum.html#reject/2).

Phoenix LiveView is still pre 1.0 so be sure to reference the [documentation](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html) as you search for information about phx-click and phx-hook.

## License

Copyright © 2021 Toran Billups https://toranbillups.com

Licensed under the MIT License
