defmodule Game.EngineTest do
  use ExUnit.Case, async: true

  alias Game.Card

  @game_name "apple-9395"
  @playing_cards ["jack", "king"]
  @image_one "/images/cards/one"
  @image_two "/images/cards/two"
  @image_three "/images/cards/three"
  @image_four "/images/cards/four"
  @id_jack_one "09011E9F1"
  @id_jack_two "09011E9F2"
  @id_jack_three "09011E9F3"
  @id_jack_four "09011E9F4"
  @id_king_one "78AAB0BF1"
  @id_king_two "78AAB0BF2"
  @id_king_three "78AAB0BF3"
  @id_king_four "78AAB0BF4"
  @id_ten_one "E6AAE3721"
  @id_ten_two "E6AAE3722"
  @id_ten_three "E6AAE3723"
  @id_ten_four "E6AAE3724"
  @id_two_one "307982591"
  @id_two_two "307982592"
  @id_two_three "307982593"
  @id_two_four "307982594"

  test "new returns game struct with list of cards" do
    state = Game.Engine.new(@game_name, @playing_cards, false)

    %Game.Engine{cards: cards, winner: winner} = state

    assert winner == nil
    assert Enum.count(cards) == 8

    [
      %Card{id: id_jack_one, name: name_jack_one, image: image_jack_one, staged: staged_jack_one},
      %Card{id: id_jack_two, name: name_jack_two, image: image_jack_two, staged: staged_jack_two},
      %Card{
        id: id_jack_three,
        name: name_jack_three,
        image: image_jack_three,
        staged: staged_jack_three
      },
      %Card{
        id: id_jack_four,
        name: name_jack_four,
        image: image_jack_four,
        staged: staged_jack_four
      },
      %Card{id: id_king_one, name: name_king_one, image: image_king_one, staged: staged_king_one},
      %Card{id: id_king_two, name: name_king_two, image: image_king_two, staged: staged_king_two},
      %Card{
        id: id_king_three,
        name: name_king_three,
        image: image_king_three,
        staged: staged_king_three
      },
      %Card{
        id: id_king_four,
        name: name_king_four,
        image: image_king_four,
        staged: staged_king_four
      }
    ] = cards

    assert id_jack_one == @id_jack_one
    assert image_jack_one == "#{@image_one}/jack_one@2x.png"
    assert name_jack_one == "jack"
    assert staged_jack_one == false

    assert id_jack_two == @id_jack_two
    assert image_jack_two == "#{@image_two}/jack_two@2x.png"
    assert name_jack_two == "jack"
    assert staged_jack_two == false

    assert id_jack_three == @id_jack_three
    assert image_jack_three == "#{@image_three}/jack_three@2x.png"
    assert name_jack_three == "jack"
    assert staged_jack_three == false

    assert id_jack_four == @id_jack_four
    assert image_jack_four == "#{@image_four}/jack_four@2x.png"
    assert name_jack_four == "jack"
    assert staged_jack_four == false

    assert id_king_one == @id_king_one
    assert image_king_one == "#{@image_one}/king_one@2x.png"
    assert name_king_one == "king"
    assert staged_king_one == false

    assert id_king_two == @id_king_two
    assert image_king_two == "#{@image_two}/king_two@2x.png"
    assert name_king_two == "king"
    assert staged_king_two == false

    assert id_king_three == @id_king_three
    assert image_king_three == "#{@image_three}/king_three@2x.png"
    assert name_king_three == "king"
    assert staged_king_three == false

    assert id_king_four == @id_king_four
    assert image_king_four == "#{@image_four}/king_four@2x.png"
    assert name_king_four == "king"
    assert staged_king_four == false
  end

  test "stage will mark a given card with staged attribute" do
    state = %Game.Engine{
      player_hands: %{
        "01D3CC" => [
          %Card{:id => @id_jack_one, :name => "jack", :staged => false, :points => 10},
          %Card{:id => @id_jack_two, :name => "jack", :staged => false, :points => 10},
          %Card{:id => @id_jack_three, :name => "jack", :staged => false, :points => 10},
          %Card{:id => @id_jack_four, :name => "jack", :staged => false, :points => 10}
        ],
        "EBDA4E" => [
          %Card{:id => @id_king_one, :name => "king", :staged => false, :points => 12},
          %Card{:id => @id_king_two, :name => "king", :staged => false, :points => 12},
          %Card{:id => @id_king_three, :name => "king", :staged => false, :points => 12},
          %Card{:id => @id_king_four, :name => "king", :staged => false, :points => 12}
        ]
      },
      players: [
        "EBDA4E",
        "01D3CC"
      ],
      active_player_id: "01D3CC"
    }

    new_state = Game.Engine.stage(state, @id_jack_one, "01D3CC")

    %Game.Engine{player_hands: player_hands, scores: scores} = new_state
    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "01D3CC" end)

    [
      %Card{staged: staged_jack_one},
      %Card{staged: staged_jack_two},
      %Card{staged: staged_jack_three},
      %Card{staged: staged_jack_four}
    ] = cards

    assert staged_jack_one == true
    assert staged_jack_two == false
    assert staged_jack_three == false
    assert staged_jack_four == false

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "EBDA4E" end)

    [
      %Card{staged: staged_king_one},
      %Card{staged: staged_king_two},
      %Card{staged: staged_king_three},
      %Card{staged: staged_king_four}
    ] = cards

    assert staged_king_one == false
    assert staged_king_two == false
    assert staged_king_three == false
    assert staged_king_four == false

    assert scores == %{}
  end

  test "staging will NOT mark the cards as staged when player_id is not active" do
    state = %Game.Engine{
      player_hands: %{
        "01D3CC" => [
          %Card{:id => @id_jack_one, :name => "jack", :staged => false, :points => 10},
          %Card{:id => @id_jack_two, :name => "jack", :staged => false, :points => 10},
          %Card{:id => @id_jack_three, :name => "jack", :staged => false, :points => 10},
          %Card{:id => @id_jack_four, :name => "jack", :staged => false, :points => 10}
        ],
        "EBDA4E" => [
          %Card{:id => @id_king_one, :name => "king", :staged => false, :points => 12},
          %Card{:id => @id_king_two, :name => "king", :staged => false, :points => 12},
          %Card{:id => @id_king_three, :name => "king", :staged => false, :points => 12},
          %Card{:id => @id_king_four, :name => "king", :staged => false, :points => 12}
        ]
      },
      players: [
        "EBDA4E",
        "01D3CC"
      ],
      active_player_id: "EBDA4E"
    }

    new_state = Game.Engine.stage(state, @id_jack_one, "01D3CC")

    %Game.Engine{player_hands: player_hands, scores: scores} = new_state
    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "01D3CC" end)

    [
      %Card{staged: staged_jack_one},
      %Card{staged: staged_jack_two},
      %Card{staged: staged_jack_three},
      %Card{staged: staged_jack_four}
    ] = cards

    assert staged_jack_one == false
    assert staged_jack_two == false
    assert staged_jack_three == false
    assert staged_jack_four == false

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "EBDA4E" end)

    [
      %Card{staged: staged_king_one},
      %Card{staged: staged_king_two},
      %Card{staged: staged_king_three},
      %Card{staged: staged_king_four}
    ] = cards

    assert staged_king_one == false
    assert staged_king_two == false
    assert staged_king_three == false
    assert staged_king_four == false

    assert scores == %{}
  end

  test "stage will unstage already staged card when names do not match" do
    state = %Game.Engine{
      player_hands: %{
        "01D3CC" => [
          %Card{:id => "t1", :name => "two", :staged => false, :points => 1},
          %Card{:id => "t2", :name => "two", :staged => false, :points => 1},
          %Card{:id => "j1", :name => "jack", :staged => false, :points => 10},
          %Card{:id => "a1", :name => "ace", :staged => false, :points => 13}
        ],
        "EBDA4E" => [
          %Card{:id => "th1", :name => "three", :staged => false, :points => 2},
          %Card{:id => "th2", :name => "three", :staged => false, :points => 2},
          %Card{:id => "k1", :name => "king", :staged => false, :points => 12},
          %Card{:id => "q1", :name => "queen", :staged => false, :points => 11}
        ]
      },
      players: [
        "EBDA4E",
        "01D3CC"
      ],
      active_player_id: "01D3CC"
    }

    # stage the two
    new_state = Game.Engine.stage(state, "t1", "01D3CC")

    %Game.Engine{player_hands: player_hands, scores: scores} = new_state
    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "01D3CC" end)

    [
      %Card{staged: staged_one},
      %Card{staged: staged_two},
      %Card{staged: staged_three},
      %Card{staged: staged_four}
    ] = cards

    assert staged_one == true
    assert staged_two == false
    assert staged_three == false
    assert staged_four == false

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "EBDA4E" end)

    [
      %Card{staged: staged_player_two_one},
      %Card{staged: staged_player_two_two},
      %Card{staged: staged_player_two_three},
      %Card{staged: staged_player_two_four}
    ] = cards

    assert staged_player_two_one == false
    assert staged_player_two_two == false
    assert staged_player_two_three == false
    assert staged_player_two_four == false

    assert scores == %{}

    # now stage a jack with the same player
    new_state = Game.Engine.stage(new_state, "j1", "01D3CC")

    %Game.Engine{player_hands: player_hands, scores: scores} = new_state
    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "01D3CC" end)

    [
      %Card{id: staged_id_one, staged: staged_one},
      %Card{id: staged_id_two, staged: staged_two},
      %Card{id: staged_id_three, staged: staged_three},
      %Card{id: staged_id_four, staged: staged_four}
    ] = cards

    assert staged_id_one == "t1"
    assert staged_one == false
    assert staged_id_two == "t2"
    assert staged_two == false
    assert staged_id_three == "j1"
    assert staged_three == true
    assert staged_id_four == "a1"
    assert staged_four == false

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "EBDA4E" end)

    [
      %Card{staged: staged_player_two_one},
      %Card{staged: staged_player_two_two},
      %Card{staged: staged_player_two_three},
      %Card{staged: staged_player_two_four}
    ] = cards

    assert staged_player_two_one == false
    assert staged_player_two_two == false
    assert staged_player_two_three == false
    assert staged_player_two_four == false

    assert scores == %{}
  end

  test "stage will not mark a given card when played attribute set" do
    state = %Game.Engine{
      player_hands: %{
        "01D3CC" => [
          %Card{:id => "t1", :name => "two", :staged => false, :points => 1},
          %Card{:id => "j1", :name => "jack", :staged => false, :points => 10},
          %Card{:id => "q1", :name => "queen", :staged => false, :points => 11},
          %Card{:id => "k1", :name => "king", :staged => false, :points => 12}
        ],
        "EBDA4E" => [
          %Card{:id => "t2", :name => "two", :staged => false, :points => 1},
          %Card{:id => "j2", :name => "jack", :staged => false, :points => 10},
          %Card{:id => "q2", :name => "queen", :staged => false, :points => 11},
          %Card{:id => "k2", :name => "king", :staged => false, :points => 12}
        ]
      },
      players: [
        "EBDA4E",
        "01D3CC"
      ],
      active_player_id: "01D3CC"
    }

    new_state = Game.Engine.stage(state, "t1", "01D3CC")
    play_state = Game.Engine.play(new_state, "01D3CC")

    %Game.Engine{player_hands: player_hands} = play_state
    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "01D3CC" end)

    [
      %Card{played: played_one},
      %Card{played: played_two},
      %Card{played: played_three},
      %Card{played: played_four}
    ] = cards

    assert played_one == true
    assert played_two == false
    assert played_three == false
    assert played_four == false

    new_state = Game.Engine.stage(play_state, "j2", "EBDA4E")
    play_state = Game.Engine.play(new_state, "EBDA4E")

    %Game.Engine{player_hands: player_hands, active_player_id: active_player_id} = play_state
    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "EBDA4E" end)

    [
      %Card{played: played_one},
      %Card{played: played_two},
      %Card{played: played_three},
      %Card{played: played_four}
    ] = cards

    assert played_one == false
    assert played_two == true
    assert played_three == false
    assert played_four == false

    assert active_player_id == "01D3CC"

    new_state = Game.Engine.stage(play_state, "t1", "01D3CC")
    # not playing ...play_state = Game.Engine.play(new_state, "01D3CC")

    %Game.Engine{player_hands: player_hands, active_player_id: active_player_id} = new_state
    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "01D3CC" end)

    [
      %Card{staged: staged_one, played: played_one},
      %Card{staged: staged_two, played: played_two},
      %Card{staged: staged_three, played: played_three},
      %Card{staged: staged_four, played: played_four}
    ] = cards

    assert staged_one == false
    assert staged_two == false
    assert staged_three == false
    assert staged_four == false

    assert played_one == true
    assert played_two == false
    assert played_three == false
    assert played_four == false

    assert active_player_id == "01D3CC"

    new_state = Game.Engine.stage(new_state, "t1", "01D3CC")
    play_state = Game.Engine.play(new_state, "01D3CC")

    %Game.Engine{player_hands: player_hands, active_player_id: active_player_id} = play_state
    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "01D3CC" end)

    [
      %Card{staged: staged_one, played: played_one},
      %Card{staged: staged_two, played: played_two},
      %Card{staged: staged_three, played: played_three},
      %Card{staged: staged_four, played: played_four}
    ] = cards

    assert staged_one == false
    assert staged_two == false
    assert staged_three == false
    assert staged_four == false

    assert played_one == true
    assert played_two == false
    assert played_three == false
    assert played_four == false

    assert active_player_id == "01D3CC"
  end

  test "skip will rotate between players correctly" do
    state = %Game.Engine{
      player_hands: %{
        "01D3CC" => [
          %Card{:id => @id_jack_one, :name => "jack", :staged => false, :points => 10},
          %Card{:id => @id_jack_two, :name => "jack", :staged => false, :points => 10},
          %Card{:id => @id_jack_three, :name => "jack", :staged => false, :points => 10},
          %Card{:id => @id_jack_four, :name => "jack", :staged => false, :points => 10}
        ],
        "EBDA4E" => [
          %Card{:id => @id_king_one, :name => "king", :staged => false, :points => 12},
          %Card{:id => @id_king_two, :name => "king", :staged => false, :points => 12},
          %Card{:id => @id_king_three, :name => "king", :staged => false, :points => 12},
          %Card{:id => @id_king_four, :name => "king", :staged => false, :points => 12}
        ]
      },
      players: [
        "01D3CC",
        "EBDA4E",
        "ADDE47"
      ],
      active_player_id: "01D3CC"
    }

    state_two = Game.Engine.skip_turn(state, "01D3CC")
    %Game.Engine{active_player_id: active_player_id} = state_two

    assert active_player_id == "EBDA4E"

    state_three = Game.Engine.skip_turn(state_two, "EBDA4E")
    %Game.Engine{active_player_id: active_player_id} = state_three

    assert active_player_id == "ADDE47"
  end

  test "skip will NOT rotate between players when skip is not active player" do
    state = %Game.Engine{
      player_hands: %{
        "01D3CC" => [
          %Card{:id => @id_jack_one, :name => "jack", :staged => false, :points => 10},
          %Card{:id => @id_jack_two, :name => "jack", :staged => false, :points => 10},
          %Card{:id => @id_jack_three, :name => "jack", :staged => false, :points => 10},
          %Card{:id => @id_jack_four, :name => "jack", :staged => false, :points => 10}
        ],
        "EBDA4E" => [
          %Card{:id => @id_king_one, :name => "king", :staged => false, :points => 12},
          %Card{:id => @id_king_two, :name => "king", :staged => false, :points => 12},
          %Card{:id => @id_king_three, :name => "king", :staged => false, :points => 12},
          %Card{:id => @id_king_four, :name => "king", :staged => false, :points => 12}
        ]
      },
      players: [
        "01D3CC",
        "EBDA4E",
        "ADDE47"
      ],
      active_player_id: "01D3CC"
    }

    state_two = Game.Engine.skip_turn(state, "ADDE47")
    %Game.Engine{active_player_id: active_player_id} = state_two

    assert active_player_id == "01D3CC"
  end

  test "join will add player_id to players list and leave will remove player_id from players list" do
    state = %Game.Engine{
      cards: [
        %Card{:id => @id_jack_one, :name => "jack", :staged => false},
        %Card{:id => @id_jack_two, :name => "jack", :staged => false},
        %Card{:id => @id_jack_three, :name => "jack", :staged => false},
        %Card{:id => @id_jack_four, :name => "jack", :staged => false},
        %Card{:id => @id_king_one, :name => "king", :staged => false},
        %Card{:id => @id_king_two, :name => "king", :staged => false},
        %Card{:id => @id_king_three, :name => "king", :staged => false},
        %Card{:id => @id_king_four, :name => "king", :staged => false}
      ]
    }

    {:ok, new_state} = Game.Engine.join(state, "01D3CC")

    %Game.Engine{active_player_id: active_player_id, players: players} = new_state
    [player] = players

    assert Enum.count(players) == 1
    assert active_player_id == "01D3CC"
    assert player == "01D3CC"

    leave_state = Game.Engine.leave(new_state, "01D3CC")

    %Game.Engine{active_player_id: active_player_id, players: players} = leave_state

    assert Enum.count(players) == 0
    assert active_player_id == nil
  end

  test "join will allow up to 8 players in total" do
    state = %Game.Engine{
      cards: [
        %Card{:id => @id_jack_one, :name => "jack", :staged => false},
        %Card{:id => @id_jack_two, :name => "jack", :staged => false},
        %Card{:id => @id_jack_three, :name => "jack", :staged => false},
        %Card{:id => @id_jack_four, :name => "jack", :staged => false},
        %Card{:id => @id_king_one, :name => "king", :staged => false},
        %Card{:id => @id_king_two, :name => "king", :staged => false},
        %Card{:id => @id_king_three, :name => "king", :staged => false},
        %Card{:id => @id_king_four, :name => "king", :staged => false}
      ]
    }

    {:ok, one_state} = Game.Engine.join(state, "01D3CC")

    %Game.Engine{active_player_id: active_player_id, players: players} = one_state
    [player] = players

    assert Enum.count(players) == 1
    assert active_player_id == "01D3CC"
    assert player == "01D3CC"

    {:ok, two_state} = Game.Engine.join(one_state, "EBDA4E")

    %Game.Engine{active_player_id: active_player_id, players: players} = two_state
    [one, two] = players

    assert Enum.count(players) == 2
    assert active_player_id == "01D3CC"
    assert one == "EBDA4E"
    assert two == "01D3CC"

    {:ok, three_state} = Game.Engine.join(two_state, "ADDE47")

    %Game.Engine{active_player_id: active_player_id, players: players} = three_state
    [one, two, three] = players

    assert Enum.count(players) == 3
    assert active_player_id == "01D3CC"
    assert one == "ADDE47"
    assert two == "EBDA4E"
    assert three == "01D3CC"
  end

  test "join will blow up if the game is already started" do
    state = %Game.Engine{
      cards: [
        %Card{:id => @id_jack_one, :name => "jack", :staged => false},
        %Card{:id => @id_jack_two, :name => "jack", :staged => false},
        %Card{:id => @id_jack_three, :name => "jack", :staged => false},
        %Card{:id => @id_jack_four, :name => "jack", :staged => false},
        %Card{:id => @id_king_one, :name => "king", :staged => false},
        %Card{:id => @id_king_two, :name => "king", :staged => false},
        %Card{:id => @id_king_three, :name => "king", :staged => false},
        %Card{:id => @id_king_four, :name => "king", :staged => false}
      ]
    }

    {:ok, one_state} = Game.Engine.join(state, "01D3CC")

    %Game.Engine{active_player_id: active_player_id, players: players} = one_state
    [player] = players

    assert Enum.count(players) == 1
    assert active_player_id == "01D3CC"
    assert player == "01D3CC"

    {:ok, two_state} = Game.Engine.join(one_state, "EBDA4E")

    %Game.Engine{active_player_id: active_player_id, players: players} = two_state
    [one, two] = players

    assert Enum.count(players) == 2
    assert active_player_id == "01D3CC"
    assert one == "EBDA4E"
    assert two == "01D3CC"

    assert two_state.started_at == nil

    new_state = Game.Engine.started(two_state, false)

    assert new_state.started_at != nil

    {:error, reason} = Game.Engine.join(new_state, "ADDE47")

    assert reason == "join failed: game was full or started"
  end

  test "join will not blow up if the player_id was in from the start" do
    state = %Game.Engine{
      cards: [
        %Card{:id => @id_jack_one, :name => "jack", :staged => false},
        %Card{:id => @id_jack_two, :name => "jack", :staged => false},
        %Card{:id => @id_jack_three, :name => "jack", :staged => false},
        %Card{:id => @id_jack_four, :name => "jack", :staged => false},
        %Card{:id => @id_king_one, :name => "king", :staged => false},
        %Card{:id => @id_king_two, :name => "king", :staged => false},
        %Card{:id => @id_king_three, :name => "king", :staged => false},
        %Card{:id => @id_king_four, :name => "king", :staged => false}
      ]
    }

    {:ok, new_state} = Game.Engine.join(state, "01D3CC")

    %Game.Engine{active_player_id: active_player_id, players: players} = new_state
    [player_one] = players

    assert Enum.count(players) == 1
    assert active_player_id == "01D3CC"
    assert player_one == "01D3CC"

    {:ok, new_state} = Game.Engine.join(new_state, "EBDA4E")

    %Game.Engine{active_player_id: active_player_id, players: players} = new_state
    [player_one, player_two] = players

    assert Enum.count(players) == 2
    assert active_player_id == "01D3CC"
    assert player_one == "EBDA4E"
    assert player_two == "01D3CC"

    new_state = Game.Engine.started(new_state, false)
    assert new_state.started_at != nil

    leave_state = Game.Engine.leave(new_state, "01D3CC")

    %Game.Engine{active_player_id: active_player_id, players: players} = leave_state
    [player_one] = players

    assert Enum.count(players) == 1
    assert active_player_id == "EBDA4E"
    assert player_one == "EBDA4E"

    {:ok, join_state} = Game.Engine.join(leave_state, "01D3CC")

    %Game.Engine{active_player_id: active_player_id, players: players} = join_state
    [player_one, player_two] = players

    assert Enum.count(players) == 2
    assert active_player_id == "EBDA4E"
    assert player_one == "01D3CC"
    assert player_two == "EBDA4E"
  end

  test "started will set the started at and deal out player hands" do
    state = Game.Engine.new(@game_name, ["two", "ten", "jack", "king"], false)

    {:ok, new_state} = Game.Engine.join(state, "01D3CC")
    {:ok, new_state} = Game.Engine.join(new_state, "EBDA4E")
    {:ok, new_state} = Game.Engine.join(new_state, "ADDE47")
    {:ok, new_state} = Game.Engine.join(new_state, "ZWRX21")

    assert new_state.player_hands == %{}

    started_state = Game.Engine.started(new_state, false)

    assert started_state.started_at != nil

    {_key, hand_one} = started_state.player_hands |> Enum.find(fn {k, _v} -> k == "01D3CC" end)
    assert Enum.count(hand_one) == 4

    [
      %Card{id: id_king_one, name: name_king_one},
      %Card{id: id_king_two, name: name_king_two},
      %Card{id: id_king_three, name: name_king_three},
      %Card{id: id_king_four, name: name_king_four}
    ] = hand_one

    assert id_king_one == @id_king_one
    assert name_king_one == "king"
    assert id_king_two == @id_king_two
    assert name_king_two == "king"
    assert id_king_three == @id_king_three
    assert name_king_three == "king"
    assert id_king_four == @id_king_four
    assert name_king_four == "king"

    {_key, hand_two} = started_state.player_hands |> Enum.find(fn {k, _v} -> k == "EBDA4E" end)
    assert Enum.count(hand_two) == 4

    [
      %Card{id: id_jack_one, name: name_jack_one},
      %Card{id: id_jack_two, name: name_jack_two},
      %Card{id: id_jack_three, name: name_jack_three},
      %Card{id: id_jack_four, name: name_jack_four}
    ] = hand_two

    assert id_jack_one == @id_jack_one
    assert name_jack_one == "jack"
    assert id_jack_two == @id_jack_two
    assert name_jack_two == "jack"
    assert id_jack_three == @id_jack_three
    assert name_jack_three == "jack"
    assert id_jack_four == @id_jack_four
    assert name_jack_four == "jack"

    {_key, hand_three} = started_state.player_hands |> Enum.find(fn {k, _v} -> k == "ADDE47" end)
    assert Enum.count(hand_three) == 4

    [
      %Card{id: id_ten_one, name: name_ten_one},
      %Card{id: id_ten_two, name: name_ten_two},
      %Card{id: id_ten_three, name: name_ten_three},
      %Card{id: id_ten_four, name: name_ten_four}
    ] = hand_three

    assert id_ten_one == @id_ten_one
    assert name_ten_one == "ten"
    assert id_ten_two == @id_ten_two
    assert name_ten_two == "ten"
    assert id_ten_three == @id_ten_three
    assert name_ten_three == "ten"
    assert id_ten_four == @id_ten_four
    assert name_ten_four == "ten"

    {_key, hand_four} = started_state.player_hands |> Enum.find(fn {k, _v} -> k == "ZWRX21" end)
    assert Enum.count(hand_four) == 4

    [
      %Card{id: id_two_one, name: name_two_one},
      %Card{id: id_two_two, name: name_two_two},
      %Card{id: id_two_three, name: name_two_three},
      %Card{id: id_two_four, name: name_two_four}
    ] = hand_four

    assert id_two_one == @id_two_one
    assert name_two_one == "two"
    assert id_two_two == @id_two_two
    assert name_two_two == "two"
    assert id_two_three == @id_two_three
    assert name_two_three == "two"
    assert id_two_four == @id_two_four
    assert name_two_four == "two"
  end

  test "play will mark any staged cards with played attribute" do
    state = %Game.Engine{
      player_hands: %{
        "01D3CC" => [
          %Card{:id => "1", :name => "two", :staged => false, :points => 1},
          %Card{:id => "3", :name => "four", :staged => false, :points => 3},
          %Card{:id => "5", :name => "jack", :staged => false, :points => 10},
          %Card{:id => "7", :name => "ace", :staged => false, :points => 13}
        ],
        "EBDA4E" => [
          %Card{:id => "2", :name => "three", :staged => false, :points => 2},
          %Card{:id => "4", :name => "five", :staged => false, :points => 4},
          %Card{:id => "6", :name => "king", :staged => false, :points => 12},
          %Card{:id => "8", :name => "queen", :staged => false, :points => 11}
        ]
      },
      players: [
        "EBDA4E",
        "01D3CC"
      ],
      active_player_id: "01D3CC"
    }

    # card 1
    new_state = Game.Engine.stage(state, "1", "01D3CC")
    play_state = Game.Engine.play(new_state, "01D3CC")

    %Game.Engine{
      winner: winner,
      current: current,
      ranks: ranks,
      player_hands: player_hands,
      scores: scores,
      active_player_id: active_player_id
    } = play_state

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "01D3CC" end)

    [
      %Card{staged: staged_one, played: played_one},
      %Card{staged: staged_two, played: played_two},
      %Card{staged: staged_three, played: played_three},
      %Card{staged: staged_four, played: played_four}
    ] = cards

    assert staged_one == false
    assert staged_two == false
    assert staged_three == false
    assert staged_four == false

    assert played_one == true
    assert played_two == false
    assert played_three == false
    assert played_four == false

    assert scores == %{"01D3CC" => 1}
    assert ranks == []
    assert active_player_id == "EBDA4E"
    [current_card] = current
    assert current_card.name == "two"
    assert winner == nil

    # card 2
    new_state = Game.Engine.stage(play_state, "2", "EBDA4E")
    play_state = Game.Engine.play(new_state, "EBDA4E")

    %Game.Engine{
      winner: winner,
      current: current,
      ranks: ranks,
      player_hands: player_hands,
      scores: scores,
      active_player_id: active_player_id
    } = play_state

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "EBDA4E" end)

    [
      %Card{staged: staged_one, played: played_one},
      %Card{staged: staged_two, played: played_two},
      %Card{staged: staged_three, played: played_three},
      %Card{staged: staged_four, played: played_four}
    ] = cards

    assert staged_one == false
    assert staged_two == false
    assert staged_three == false
    assert staged_four == false

    assert played_one == true
    assert played_two == false
    assert played_three == false
    assert played_four == false

    assert scores == %{"01D3CC" => 1, "EBDA4E" => 1}
    assert ranks == []
    assert active_player_id == "01D3CC"
    [current_card] = current
    assert current_card.name == "three"
    assert winner == nil

    # card 3
    new_state = Game.Engine.stage(play_state, "3", "01D3CC")
    play_state = Game.Engine.play(new_state, "01D3CC")

    %Game.Engine{
      winner: winner,
      current: current,
      ranks: ranks,
      player_hands: player_hands,
      scores: scores,
      active_player_id: active_player_id
    } = play_state

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "01D3CC" end)

    [
      %Card{staged: staged_one, played: played_one},
      %Card{staged: staged_two, played: played_two},
      %Card{staged: staged_three, played: played_three},
      %Card{staged: staged_four, played: played_four}
    ] = cards

    assert staged_one == false
    assert staged_two == false
    assert staged_three == false
    assert staged_four == false

    assert played_one == true
    assert played_two == true
    assert played_three == false
    assert played_four == false

    assert scores == %{"01D3CC" => 2, "EBDA4E" => 1}
    assert ranks == []
    assert active_player_id == "EBDA4E"
    [current_card] = current
    assert current_card.name == "four"
    assert winner == nil

    # card 4
    new_state = Game.Engine.stage(play_state, "4", "EBDA4E")
    play_state = Game.Engine.play(new_state, "EBDA4E")

    %Game.Engine{
      winner: winner,
      current: current,
      ranks: ranks,
      player_hands: player_hands,
      scores: scores,
      active_player_id: active_player_id
    } = play_state

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "EBDA4E" end)

    [
      %Card{staged: staged_one, played: played_one},
      %Card{staged: staged_two, played: played_two},
      %Card{staged: staged_three, played: played_three},
      %Card{staged: staged_four, played: played_four}
    ] = cards

    assert staged_one == false
    assert staged_two == false
    assert staged_three == false
    assert staged_four == false

    assert played_one == true
    assert played_two == true
    assert played_three == false
    assert played_four == false

    assert scores == %{"01D3CC" => 2, "EBDA4E" => 2}
    assert ranks == []
    assert active_player_id == "01D3CC"
    [current_card] = current
    assert current_card.name == "five"
    assert winner == nil

    # card 5
    new_state = Game.Engine.stage(play_state, "5", "01D3CC")
    play_state = Game.Engine.play(new_state, "01D3CC")

    %Game.Engine{
      winner: winner,
      current: current,
      ranks: ranks,
      player_hands: player_hands,
      scores: scores,
      active_player_id: active_player_id
    } = play_state

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "01D3CC" end)

    [
      %Card{staged: staged_one, played: played_one},
      %Card{staged: staged_two, played: played_two},
      %Card{staged: staged_three, played: played_three},
      %Card{staged: staged_four, played: played_four}
    ] = cards

    assert staged_one == false
    assert staged_two == false
    assert staged_three == false
    assert staged_four == false

    assert played_one == true
    assert played_two == true
    assert played_three == true
    assert played_four == false

    assert scores == %{"01D3CC" => 3, "EBDA4E" => 2}
    assert ranks == []
    assert active_player_id == "EBDA4E"
    [current_card] = current
    assert current_card.name == "jack"
    assert winner == nil

    # card 6
    new_state = Game.Engine.stage(play_state, "6", "EBDA4E")
    play_state = Game.Engine.play(new_state, "EBDA4E")

    %Game.Engine{
      winner: winner,
      current: current,
      ranks: ranks,
      player_hands: player_hands,
      scores: scores,
      active_player_id: active_player_id
    } = play_state

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "EBDA4E" end)

    [
      %Card{staged: staged_one, played: played_one},
      %Card{staged: staged_two, played: played_two},
      %Card{staged: staged_three, played: played_three},
      %Card{staged: staged_four, played: played_four}
    ] = cards

    assert staged_one == false
    assert staged_two == false
    assert staged_three == false
    assert staged_four == false

    assert played_one == true
    assert played_two == true
    assert played_three == true
    assert played_four == false

    assert scores == %{"01D3CC" => 3, "EBDA4E" => 3}
    assert ranks == []
    assert active_player_id == "01D3CC"
    [current_card] = current
    assert current_card.name == "king"
    assert winner == nil

    # card 7
    new_state = Game.Engine.stage(play_state, "7", "01D3CC")
    play_state = Game.Engine.play(new_state, "01D3CC")

    %Game.Engine{
      winner: winner,
      current: current,
      ranks: ranks,
      player_hands: player_hands,
      scores: scores,
      active_player_id: active_player_id
    } = play_state

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "01D3CC" end)

    [
      %Card{staged: staged_one, played: played_one},
      %Card{staged: staged_two, played: played_two},
      %Card{staged: staged_three, played: played_three},
      %Card{staged: staged_four, played: played_four}
    ] = cards

    assert staged_one == false
    assert staged_two == false
    assert staged_three == false
    assert staged_four == false

    assert played_one == true
    assert played_two == true
    assert played_three == true
    assert played_four == true

    assert scores == %{"01D3CC" => 4, "EBDA4E" => 3}
    assert ranks == ["01D3CC"]
    assert active_player_id == "01D3CC"
    [current_card] = current
    assert current_card.name == "ace"
    assert winner == "01D3CC"
    # because the game is over
    # assert active_player_id == "EBDA4E"
    # assert Enum.count(current) == 0
  end

  test "play with less powerful card will simply return the game state unchanged" do
    state = %Game.Engine{
      player_hands: %{
        "01D3CC" => [
          %Card{:id => "1", :name => "two", :staged => false, :points => 1},
          %Card{:id => "3", :name => "four", :staged => false, :points => 3},
          %Card{:id => "5", :name => "jack", :staged => false, :points => 10},
          %Card{:id => "7", :name => "ace", :staged => false, :points => 13}
        ],
        "EBDA4E" => [
          %Card{:id => "2", :name => "three", :staged => false, :points => 2},
          %Card{:id => "4", :name => "five", :staged => false, :points => 4},
          %Card{:id => "6", :name => "king", :staged => false, :points => 12},
          %Card{:id => "8", :name => "queen", :staged => false, :points => 11}
        ]
      },
      players: [
        "EBDA4E",
        "01D3CC"
      ],
      active_player_id: "01D3CC"
    }

    new_state = Game.Engine.stage(state, "5", "01D3CC")

    %Game.Engine{
      current: current,
      player_hands: player_hands,
      active_player_id: active_player_id
    } = new_state

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "01D3CC" end)

    [
      %Card{staged: staged_one, played: played_one},
      %Card{staged: staged_two, played: played_two},
      %Card{staged: staged_three, played: played_three},
      %Card{staged: staged_four, played: played_four}
    ] = cards

    assert staged_one == false
    assert staged_two == false
    assert staged_three == true
    assert staged_four == false

    assert played_one == false
    assert played_two == false
    assert played_three == false
    assert played_four == false
    assert current == []
    assert active_player_id == "01D3CC"

    play_state = Game.Engine.play(new_state, "01D3CC")

    %Game.Engine{
      current: current,
      ranks: ranks,
      scores: scores,
      active_player_id: active_player_id
    } = play_state

    assert scores == %{"01D3CC" => 1}
    assert ranks == []
    assert active_player_id == "EBDA4E"
    [current_card] = current
    assert current_card.name == "jack"

    # weak card
    new_state = Game.Engine.stage(play_state, "2", "EBDA4E")
    play_state = Game.Engine.play(new_state, "EBDA4E")

    %Game.Engine{
      current: current,
      ranks: ranks,
      player_hands: player_hands,
      scores: scores,
      active_player_id: active_player_id
    } = play_state

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "EBDA4E" end)

    [
      %Card{id: id_one, staged: staged_one, played: played_one},
      %Card{id: id_two, staged: staged_two, played: played_two},
      %Card{id: id_three, staged: staged_three, played: played_three},
      %Card{id: id_four, staged: staged_four, played: played_four}
    ] = cards

    assert id_one == "2"
    assert staged_one == true
    assert id_two == "4"
    assert staged_two == false
    assert id_three == "6"
    assert staged_three == false
    assert id_four == "8"
    assert staged_four == false

    assert played_one == false
    assert played_two == false
    assert played_three == false
    assert played_four == false

    assert scores == %{"01D3CC" => 1}
    assert ranks == []
    assert active_player_id == "EBDA4E"
    [current_card] = current
    assert current_card.name == "jack"
  end

  test "play with two cards of greater value score as expected" do
    state = %Game.Engine{
      player_hands: %{
        "01D3CC" => [
          %Card{:id => "t1", :name => "two", :staged => false, :points => 1},
          %Card{:id => "t2", :name => "two", :staged => false, :points => 1},
          %Card{:id => "j1", :name => "jack", :staged => false, :points => 10},
          %Card{:id => "a1", :name => "ace", :staged => false, :points => 13}
        ],
        "EBDA4E" => [
          %Card{:id => "th1", :name => "three", :staged => false, :points => 2},
          %Card{:id => "th2", :name => "three", :staged => false, :points => 2},
          %Card{:id => "k1", :name => "king", :staged => false, :points => 12},
          %Card{:id => "q1", :name => "queen", :staged => false, :points => 11}
        ]
      },
      players: [
        "EBDA4E",
        "01D3CC"
      ],
      active_player_id: "01D3CC"
    }

    new_state = Game.Engine.stage(state, "t1", "01D3CC")
    new_state = Game.Engine.stage(new_state, "t2", "01D3CC")

    %Game.Engine{
      current: current,
      player_hands: player_hands,
      active_player_id: active_player_id
    } = new_state

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "01D3CC" end)

    [
      %Card{staged: staged_one, played: played_one},
      %Card{staged: staged_two, played: played_two},
      %Card{staged: staged_three, played: played_three},
      %Card{staged: staged_four, played: played_four}
    ] = cards

    assert staged_one == true
    assert staged_two == true
    assert staged_three == false
    assert staged_four == false

    assert played_one == false
    assert played_two == false
    assert played_three == false
    assert played_four == false
    assert current == []
    assert active_player_id == "01D3CC"

    play_state = Game.Engine.play(new_state, "01D3CC")

    %Game.Engine{
      current: current,
      ranks: ranks,
      scores: scores,
      active_player_id: active_player_id
    } = play_state

    assert scores == %{"01D3CC" => 1}
    assert ranks == []
    assert active_player_id == "EBDA4E"
    [current_card, _] = current
    assert current_card.name == "two"

    # solo card to start
    new_state = Game.Engine.stage(play_state, "th1", "EBDA4E")
    play_state = Game.Engine.play(new_state, "EBDA4E")

    %Game.Engine{
      current: current,
      ranks: ranks,
      player_hands: player_hands,
      scores: scores,
      active_player_id: active_player_id
    } = play_state

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "EBDA4E" end)

    [
      %Card{id: id_one, staged: staged_one, played: played_one},
      %Card{id: id_two, staged: staged_two, played: played_two},
      %Card{id: id_three, staged: staged_three, played: played_three},
      %Card{id: id_four, staged: staged_four, played: played_four}
    ] = cards

    assert id_one == "th1"
    assert staged_one == true
    assert id_two == "th2"
    assert staged_two == false
    assert id_three == "k1"
    assert staged_three == false
    assert id_four == "q1"
    assert staged_four == false

    assert played_one == false
    assert played_two == false
    assert played_three == false
    assert played_four == false

    assert scores == %{"01D3CC" => 1}
    assert ranks == []
    assert active_player_id == "EBDA4E"
    [current_card, _] = current
    assert current_card.name == "two"

    # double staged
    new_state = Game.Engine.stage(play_state, "th2", "EBDA4E")

    %Game.Engine{
      current: current,
      ranks: ranks,
      player_hands: player_hands,
      scores: scores,
      active_player_id: active_player_id
    } = new_state

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "EBDA4E" end)

    [
      %Card{id: id_one, staged: staged_one, played: played_one},
      %Card{id: id_two, staged: staged_two, played: played_two},
      %Card{id: id_three, staged: staged_three, played: played_three},
      %Card{id: id_four, staged: staged_four, played: played_four}
    ] = cards

    assert id_one == "th1"
    assert staged_one == true
    assert id_two == "th2"
    assert staged_two == true
    assert id_three == "k1"
    assert staged_three == false
    assert id_four == "q1"
    assert staged_four == false

    assert played_one == false
    assert played_two == false
    assert played_three == false
    assert played_four == false

    assert scores == %{"01D3CC" => 1}
    assert ranks == []
    assert active_player_id == "EBDA4E"
    [current_card, _] = current
    assert current_card.name == "two"

    # double played
    play_state = Game.Engine.play(new_state, "EBDA4E")

    %Game.Engine{
      current: current,
      ranks: ranks,
      player_hands: player_hands,
      scores: scores,
      active_player_id: active_player_id
    } = play_state

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "EBDA4E" end)

    [
      %Card{id: id_one, staged: staged_one, played: played_one},
      %Card{id: id_two, staged: staged_two, played: played_two},
      %Card{id: id_three, staged: staged_three, played: played_three},
      %Card{id: id_four, staged: staged_four, played: played_four}
    ] = cards

    assert id_one == "th1"
    assert staged_one == false
    assert id_two == "th2"
    assert staged_two == false
    assert id_three == "k1"
    assert staged_three == false
    assert id_four == "q1"
    assert staged_four == false

    assert played_one == true
    assert played_two == true
    assert played_three == false
    assert played_four == false

    assert scores == %{"01D3CC" => 1, "EBDA4E" => 1}
    assert ranks == []
    assert active_player_id == "01D3CC"
    [current_card, _] = current
    assert current_card.name == "three"
  end

  test "play card of equal value but greater count will score but not skip next player" do
    state = %Game.Engine{
      player_hands: %{
        "01D3CC" => [
          %Card{:id => "t1", :name => "two", :staged => false, :points => 1},
          %Card{:id => "t2", :name => "two", :staged => false, :points => 1},
          %Card{:id => "j1", :name => "jack", :staged => false, :points => 10},
          %Card{:id => "a1", :name => "ace", :staged => false, :points => 13}
        ],
        "EBDA4E" => [
          %Card{:id => "t3", :name => "two", :staged => false, :points => 1},
          %Card{:id => "t4", :name => "two", :staged => false, :points => 1},
          %Card{:id => "th1", :name => "three", :staged => false, :points => 2},
          %Card{:id => "th2", :name => "three", :staged => false, :points => 2}
        ]
      },
      players: [
        "EBDA4E",
        "01D3CC"
      ],
      active_player_id: "01D3CC"
    }

    new_state = Game.Engine.stage(state, "t1", "01D3CC")
    play_state = Game.Engine.play(new_state, "01D3CC")

    %Game.Engine{
      ranks: ranks,
      scores: scores,
      current: current,
      current_player_id: current_player_id,
      active_player_id: active_player_id
    } = play_state

    [current_card] = current
    assert current_card.name == "two"
    assert current_player_id == "01D3CC"
    assert active_player_id == "EBDA4E"
    assert scores == %{"01D3CC" => 1}
    assert ranks == []

    # now play double twos -should not skip
    new_state = Game.Engine.stage(play_state, "t3", "EBDA4E")
    next_state = Game.Engine.stage(new_state, "t4", "EBDA4E")
    play_state = Game.Engine.play(next_state, "EBDA4E")

    %Game.Engine{
      ranks: ranks,
      scores: scores,
      player_hands: player_hands,
      current: current,
      current_player_id: current_player_id,
      active_player_id: active_player_id
    } = play_state

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "EBDA4E" end)

    [
      %Card{id: id_one, staged: staged_one, played: played_one},
      %Card{id: id_two, staged: staged_two, played: played_two},
      %Card{id: id_three, staged: staged_three, played: played_three},
      %Card{id: id_four, staged: staged_four, played: played_four}
    ] = cards

    assert id_one == "t3"
    assert staged_one == false
    assert id_two == "t4"
    assert staged_two == false
    assert id_three == "th1"
    assert staged_three == false
    assert id_four == "th2"
    assert staged_four == false

    assert played_one == true
    assert played_two == true
    assert played_three == false
    assert played_four == false

    assert ranks == []
    assert scores == %{"01D3CC" => 1, "EBDA4E" => 1}
    [current_card_one, current_card_two] = current
    assert current_card_one.name == "two"
    assert current_card_two.name == "two"
    assert current_player_id == "EBDA4E"
    assert active_player_id == "01D3CC"
  end

  test "play card of equal value will score and skip next player" do
    state = %Game.Engine{
      player_hands: %{
        "01D3CC" => [
          %Card{:id => "t1", :name => "two", :staged => false, :points => 1},
          %Card{:id => "t2", :name => "two", :staged => false, :points => 1},
          %Card{:id => "j1", :name => "jack", :staged => false, :points => 10},
          %Card{:id => "a1", :name => "ace", :staged => false, :points => 13}
        ],
        "EBDA4E" => [
          %Card{:id => "t3", :name => "two", :staged => false, :points => 1},
          %Card{:id => "t4", :name => "two", :staged => false, :points => 1},
          %Card{:id => "th1", :name => "three", :staged => false, :points => 2},
          %Card{:id => "th2", :name => "three", :staged => false, :points => 2}
        ]
      },
      players: [
        "EBDA4E",
        "01D3CC"
      ],
      active_player_id: "01D3CC"
    }

    new_state = Game.Engine.stage(state, "t1", "01D3CC")
    new_state = Game.Engine.stage(new_state, "t2", "01D3CC")

    %Game.Engine{
      current: current,
      player_hands: player_hands,
      active_player_id: active_player_id
    } = new_state

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "01D3CC" end)

    [
      %Card{staged: staged_one, played: played_one},
      %Card{staged: staged_two, played: played_two},
      %Card{staged: staged_three, played: played_three},
      %Card{staged: staged_four, played: played_four}
    ] = cards

    assert staged_one == true
    assert staged_two == true
    assert staged_three == false
    assert staged_four == false

    assert played_one == false
    assert played_two == false
    assert played_three == false
    assert played_four == false
    assert current == []
    assert active_player_id == "01D3CC"

    play_state = Game.Engine.play(new_state, "01D3CC")

    %Game.Engine{
      current: current,
      ranks: ranks,
      scores: scores,
      active_player_id: active_player_id
    } = play_state

    assert scores == %{"01D3CC" => 1}
    assert ranks == []
    assert active_player_id == "EBDA4E"
    [current_card, _] = current
    assert current_card.name == "two"

    # solo card to start
    new_state = Game.Engine.stage(play_state, "t3", "EBDA4E")
    play_state = Game.Engine.play(new_state, "EBDA4E")

    %Game.Engine{
      current: current,
      ranks: ranks,
      player_hands: player_hands,
      scores: scores,
      active_player_id: active_player_id
    } = play_state

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "EBDA4E" end)

    [
      %Card{id: id_one, staged: staged_one, played: played_one},
      %Card{id: id_two, staged: staged_two, played: played_two},
      %Card{id: id_three, staged: staged_three, played: played_three},
      %Card{id: id_four, staged: staged_four, played: played_four}
    ] = cards

    assert id_one == "t3"
    assert staged_one == true
    assert id_two == "t4"
    assert staged_two == false
    assert id_three == "th1"
    assert staged_three == false
    assert id_four == "th2"
    assert staged_four == false

    assert played_one == false
    assert played_two == false
    assert played_three == false
    assert played_four == false

    assert scores == %{"01D3CC" => 1}
    assert ranks == []
    assert active_player_id == "EBDA4E"
    [current_card, _] = current
    assert current_card.name == "two"

    # double staged
    new_state = Game.Engine.stage(play_state, "t4", "EBDA4E")

    %Game.Engine{
      current: current,
      ranks: ranks,
      player_hands: player_hands,
      scores: scores,
      active_player_id: active_player_id
    } = new_state

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "EBDA4E" end)

    [
      %Card{id: id_one, staged: staged_one, played: played_one},
      %Card{id: id_two, staged: staged_two, played: played_two},
      %Card{id: id_three, staged: staged_three, played: played_three},
      %Card{id: id_four, staged: staged_four, played: played_four}
    ] = cards

    assert id_one == "t3"
    assert staged_one == true
    assert id_two == "t4"
    assert staged_two == true
    assert id_three == "th1"
    assert staged_three == false
    assert id_four == "th2"
    assert staged_four == false

    assert played_one == false
    assert played_two == false
    assert played_three == false
    assert played_four == false

    assert scores == %{"01D3CC" => 1}
    assert ranks == []
    assert active_player_id == "EBDA4E"
    [current_card, _] = current
    assert current_card.name == "two"

    # double played
    play_state = Game.Engine.play(new_state, "EBDA4E")

    %Game.Engine{
      current: current,
      ranks: ranks,
      player_hands: player_hands,
      scores: scores,
      active_player_id: active_player_id
    } = play_state

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "EBDA4E" end)

    [
      %Card{id: id_one, staged: staged_one, played: played_one},
      %Card{id: id_two, staged: staged_two, played: played_two},
      %Card{id: id_three, staged: staged_three, played: played_three},
      %Card{id: id_four, staged: staged_four, played: played_four}
    ] = cards

    assert id_one == "t3"
    assert staged_one == false
    assert id_two == "t4"
    assert staged_two == false
    assert id_three == "th1"
    assert staged_three == false
    assert id_four == "th2"
    assert staged_four == false

    assert played_one == true
    assert played_two == true
    assert played_three == false
    assert played_four == false

    assert scores == %{"01D3CC" => 1, "EBDA4E" => 1}
    assert ranks == []
    assert active_player_id == "EBDA4E"
    assert Enum.count(current) == 0
    # toran need to double check the rules on this one
    # [current_card, _] = current
    # assert current_card.name == "two"
  end

  test "play ace allows the current player to go again" do
    state = %Game.Engine{
      player_hands: %{
        "01D3CC" => [
          %Card{:id => "t1", :name => "two", :staged => false, :points => 1},
          %Card{:id => "t2", :name => "two", :staged => false, :points => 1},
          %Card{:id => "j1", :name => "jack", :staged => false, :points => 10},
          %Card{:id => "a1", :name => "ace", :staged => false, :points => 13}
        ],
        "EBDA4E" => [
          %Card{:id => "th1", :name => "three", :staged => false, :points => 2},
          %Card{:id => "th2", :name => "three", :staged => false, :points => 2},
          %Card{:id => "k1", :name => "king", :staged => false, :points => 12},
          %Card{:id => "q1", :name => "queen", :staged => false, :points => 11}
        ]
      },
      players: [
        "EBDA4E",
        "01D3CC"
      ],
      active_player_id: "01D3CC"
    }

    new_state = Game.Engine.stage(state, "j1", "01D3CC")
    play_state = Game.Engine.play(new_state, "01D3CC")

    %Game.Engine{current: current, active_player_id: active_player_id} = play_state

    assert active_player_id == "EBDA4E"
    [current_card] = current
    assert current_card.name == "jack"

    # next play is king
    new_state = Game.Engine.stage(play_state, "k1", "EBDA4E")
    play_state = Game.Engine.play(new_state, "EBDA4E")

    %Game.Engine{current: current, active_player_id: active_player_id} = play_state

    assert active_player_id == "01D3CC"
    [current_card] = current
    assert current_card.name == "king"

    # now the ace
    new_state = Game.Engine.stage(play_state, "a1", "01D3CC")
    play_state = Game.Engine.play(new_state, "01D3CC")

    %Game.Engine{
      current: current,
      ranks: ranks,
      player_hands: player_hands,
      scores: scores,
      active_player_id: active_player_id
    } = play_state

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "01D3CC" end)

    [
      %Card{id: id_one, staged: staged_one, played: played_one},
      %Card{id: id_two, staged: staged_two, played: played_two},
      %Card{id: id_three, staged: staged_three, played: played_three},
      %Card{id: id_four, staged: staged_four, played: played_four}
    ] = cards

    assert id_one == "t1"
    assert staged_one == false
    assert id_two == "t2"
    assert staged_two == false
    assert id_three == "j1"
    assert staged_three == false
    assert id_four == "a1"
    assert staged_four == false

    assert played_one == false
    assert played_two == false
    assert played_three == true
    assert played_four == true

    assert scores == %{"01D3CC" => 2, "EBDA4E" => 1}
    assert ranks == []
    assert active_player_id == "01D3CC"
    assert Enum.count(current) == 0
  end

  test "play will finish a game with 4 players as expected" do
    state = %Game.Engine{
      player_hands: %{
        "01D3CC" => [
          %Card{:id => "t1", :name => "two", :staged => false, :points => 1},
          %Card{:id => "fo1", :name => "four", :staged => false, :points => 3},
          %Card{:id => "a1", :name => "ace", :staged => false, :points => 13}
        ],
        "EBDA4E" => [
          %Card{:id => "th1", :name => "three", :staged => false, :points => 2},
          %Card{:id => "fi1", :name => "five", :staged => false, :points => 4},
          %Card{:id => "q1", :name => "queen", :staged => false, :points => 11}
        ],
        "ADDE47" => [
          %Card{:id => "t2", :name => "two", :staged => false, :points => 1},
          %Card{:id => "fo2", :name => "four", :staged => false, :points => 3},
          %Card{:id => "q2", :name => "queen", :staged => false, :points => 11}
        ],
        "MXBZ22" => [
          %Card{:id => "th2", :name => "three", :staged => false, :points => 2},
          %Card{:id => "fi2", :name => "five", :staged => false, :points => 4},
          %Card{:id => "q3", :name => "queen", :staged => false, :points => 11}
        ]
      },
      players: [
        "EBDA4E",
        "01D3CC",
        "ADDE47",
        "MXBZ22"
      ],
      active_player_id: "01D3CC"
    }

    # card 1
    new_state = Game.Engine.stage(state, "t1", "01D3CC")
    play_state = Game.Engine.play(new_state, "01D3CC")

    %Game.Engine{
      winner: winner,
      current: current,
      ranks: ranks,
      player_hands: player_hands,
      scores: scores,
      active_player_id: active_player_id
    } = play_state

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "01D3CC" end)

    [
      %Card{played: played_one},
      %Card{played: played_two},
      %Card{played: played_three}
    ] = cards

    assert played_one == true
    assert played_two == false
    assert played_three == false

    assert scores == %{"01D3CC" => 1}
    assert ranks == []
    assert active_player_id == "EBDA4E"
    [current_card] = current
    assert current_card.name == "two"
    assert winner == nil

    # card 2
    new_state = Game.Engine.stage(play_state, "th1", "EBDA4E")
    play_state = Game.Engine.play(new_state, "EBDA4E")

    %Game.Engine{
      winner: winner,
      current: current,
      ranks: ranks,
      player_hands: player_hands,
      scores: scores,
      active_player_id: active_player_id
    } = play_state

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "EBDA4E" end)

    [
      %Card{played: played_one},
      %Card{played: played_two},
      %Card{played: played_three}
    ] = cards

    assert played_one == true
    assert played_two == false
    assert played_three == false

    assert scores == %{"01D3CC" => 1, "EBDA4E" => 1}
    assert ranks == []
    assert active_player_id == "ADDE47"
    [current_card] = current
    assert current_card.name == "three"
    assert winner == nil

    # card 3
    new_state = Game.Engine.stage(play_state, "fo2", "ADDE47")
    play_state = Game.Engine.play(new_state, "ADDE47")

    %Game.Engine{
      winner: winner,
      current: current,
      ranks: ranks,
      player_hands: player_hands,
      scores: scores,
      active_player_id: active_player_id
    } = play_state

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "ADDE47" end)

    [
      %Card{played: played_one},
      %Card{played: played_two},
      %Card{played: played_three}
    ] = cards

    assert played_one == false
    assert played_two == true
    assert played_three == false

    assert scores == %{"01D3CC" => 1, "EBDA4E" => 1, "ADDE47" => 1}
    assert ranks == []
    assert active_player_id == "MXBZ22"
    [current_card] = current
    assert current_card.name == "four"
    assert winner == nil

    # card 4
    new_state = Game.Engine.stage(play_state, "fi2", "MXBZ22")
    play_state = Game.Engine.play(new_state, "MXBZ22")

    %Game.Engine{
      winner: winner,
      current: current,
      ranks: ranks,
      player_hands: player_hands,
      scores: scores,
      active_player_id: active_player_id
    } = play_state

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "MXBZ22" end)

    [
      %Card{played: played_one},
      %Card{played: played_two},
      %Card{played: played_three}
    ] = cards

    assert played_one == false
    assert played_two == true
    assert played_three == false

    assert scores == %{"01D3CC" => 1, "EBDA4E" => 1, "ADDE47" => 1, "MXBZ22" => 1}
    assert ranks == []
    assert active_player_id == "01D3CC"
    [current_card] = current
    assert current_card.name == "five"
    assert winner == nil

    # card 5
    new_state = Game.Engine.stage(play_state, "a1", "01D3CC")
    play_state = Game.Engine.play(new_state, "01D3CC")

    %Game.Engine{
      winner: winner,
      current: current,
      ranks: ranks,
      player_hands: player_hands,
      scores: scores,
      active_player_id: active_player_id
    } = play_state

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "01D3CC" end)

    [
      %Card{played: played_one},
      %Card{played: played_two},
      %Card{played: played_three}
    ] = cards

    assert played_one == true
    assert played_two == false
    assert played_three == true

    assert scores == %{"01D3CC" => 2, "EBDA4E" => 1, "ADDE47" => 1, "MXBZ22" => 1}
    assert ranks == []
    assert active_player_id == "01D3CC"
    assert Enum.count(current) == 0
    assert winner == nil

    # card 6
    new_state = Game.Engine.stage(play_state, "fo1", "01D3CC")
    play_state = Game.Engine.play(new_state, "01D3CC")

    %Game.Engine{
      winner: winner,
      current: current,
      ranks: ranks,
      player_hands: player_hands,
      scores: scores,
      active_player_id: active_player_id
    } = play_state

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "01D3CC" end)

    [
      %Card{played: played_one},
      %Card{played: played_two},
      %Card{played: played_three}
    ] = cards

    assert played_one == true
    assert played_two == true
    assert played_three == true

    assert scores == %{"01D3CC" => 3, "EBDA4E" => 1, "ADDE47" => 1, "MXBZ22" => 1}
    assert ranks == ["01D3CC"]
    assert active_player_id == "EBDA4E"
    [current_card] = current
    assert current_card.name == "four"
    assert winner == nil

    # card 7
    new_state = Game.Engine.stage(play_state, "q1", "EBDA4E")
    play_state = Game.Engine.play(new_state, "EBDA4E")

    %Game.Engine{
      winner: winner,
      current: current,
      ranks: ranks,
      player_hands: player_hands,
      scores: scores,
      active_player_id: active_player_id
    } = play_state

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "EBDA4E" end)

    [
      %Card{played: played_one},
      %Card{played: played_two},
      %Card{played: played_three}
    ] = cards

    assert played_one == true
    assert played_two == false
    assert played_three == true

    assert ranks == ["01D3CC"]
    assert scores == %{"01D3CC" => 3, "EBDA4E" => 2, "ADDE47" => 1, "MXBZ22" => 1}
    assert active_player_id == "ADDE47"
    [current_card] = current
    assert current_card.name == "queen"
    assert winner == nil

    # card 8
    new_state = Game.Engine.stage(play_state, "q2", "ADDE47")
    play_state = Game.Engine.play(new_state, "ADDE47")

    %Game.Engine{
      winner: winner,
      current: current,
      ranks: ranks,
      player_hands: player_hands,
      scores: scores,
      active_player_id: active_player_id
    } = play_state

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "ADDE47" end)

    [
      %Card{played: played_one},
      %Card{played: played_two},
      %Card{played: played_three}
    ] = cards

    assert played_one == false
    assert played_two == true
    assert played_three == true

    assert scores == %{"01D3CC" => 3, "EBDA4E" => 2, "ADDE47" => 2, "MXBZ22" => 1}
    assert ranks == ["01D3CC"]
    assert active_player_id == "EBDA4E"
    [current_card] = current
    assert current_card.name == "queen"
    assert winner == nil

    # skip turn -only has a five unplayed
    play_state = Game.Engine.skip_turn(play_state, "EBDA4E")

    %Game.Engine{
      winner: winner,
      current: current,
      ranks: ranks,
      scores: scores,
      active_player_id: active_player_id
    } = play_state

    assert scores == %{"01D3CC" => 3, "EBDA4E" => 2, "ADDE47" => 2, "MXBZ22" => 1}
    assert ranks == ["01D3CC"]
    assert active_player_id == "ADDE47"
    assert Enum.count(current) == 0
    assert winner == nil

    # card 9
    new_state = Game.Engine.stage(play_state, "t2", "ADDE47")
    play_state = Game.Engine.play(new_state, "ADDE47")

    %Game.Engine{
      winner: winner,
      current: current,
      ranks: ranks,
      player_hands: player_hands,
      scores: scores,
      active_player_id: active_player_id
    } = play_state

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "ADDE47" end)

    [
      %Card{played: played_one},
      %Card{played: played_two},
      %Card{played: played_three}
    ] = cards

    assert played_one == true
    assert played_two == true
    assert played_three == true

    assert ranks == ["01D3CC", "ADDE47"]
    assert scores == %{"01D3CC" => 3, "EBDA4E" => 2, "ADDE47" => 3, "MXBZ22" => 1}
    assert active_player_id == "MXBZ22"
    [current_card] = current
    assert current_card.name == "two"
    assert winner == nil

    # card 10
    new_state = Game.Engine.stage(play_state, "th2", "MXBZ22")
    play_state = Game.Engine.play(new_state, "MXBZ22")

    %Game.Engine{
      winner: winner,
      current: current,
      ranks: ranks,
      player_hands: player_hands,
      scores: scores,
      active_player_id: active_player_id
    } = play_state

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "MXBZ22" end)

    [
      %Card{played: played_one},
      %Card{played: played_two},
      %Card{played: played_three}
    ] = cards

    assert played_one == true
    assert played_two == true
    assert played_three == false

    assert ranks == ["01D3CC", "ADDE47"]
    assert scores == %{"01D3CC" => 3, "EBDA4E" => 2, "ADDE47" => 3, "MXBZ22" => 2}
    assert active_player_id == "EBDA4E"
    [current_card] = current
    assert current_card.name == "three"
    assert winner == nil

    # card 11
    new_state = Game.Engine.stage(play_state, "fi1", "EBDA4E")
    play_state = Game.Engine.play(new_state, "EBDA4E")

    %Game.Engine{
      winner: winner,
      current: current,
      ranks: ranks,
      player_hands: player_hands,
      scores: scores,
      active_player_id: active_player_id
    } = play_state

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "EBDA4E" end)

    [
      %Card{played: played_one},
      %Card{played: played_two},
      %Card{played: played_three}
    ] = cards

    assert played_one == true
    assert played_two == true
    assert played_three == true

    assert ranks == ["01D3CC", "ADDE47", "EBDA4E"]
    assert scores == %{"01D3CC" => 3, "EBDA4E" => 3, "ADDE47" => 3, "MXBZ22" => 2}
    assert active_player_id == "EBDA4E"
    assert Enum.count(current) == 0
    assert winner == "01D3CC"
    # because the game is over we don't flip active player to next
    # and we clear the current
  end

  test "play will finish a game with 4 players as expected alt ending" do
    state = %Game.Engine{
      playing_cards: ["two", "three", "four", "five", "queen", "ace"],
      player_hands: %{
        "01D3CC" => [
          %Card{:id => "t1", :name => "two", :staged => false, :points => 1},
          %Card{:id => "fo1", :name => "four", :staged => false, :points => 3},
          %Card{:id => "a1", :name => "ace", :staged => false, :points => 13}
        ],
        "EBDA4E" => [
          %Card{:id => "th1", :name => "three", :staged => false, :points => 2},
          %Card{:id => "fi1", :name => "five", :staged => false, :points => 4},
          %Card{:id => "q1", :name => "queen", :staged => false, :points => 11}
        ],
        "ADDE47" => [
          %Card{:id => "t2", :name => "two", :staged => false, :points => 1},
          %Card{:id => "fo2", :name => "four", :staged => false, :points => 3},
          %Card{:id => "q2", :name => "queen", :staged => false, :points => 11}
        ],
        "MXBZ22" => [
          %Card{:id => "th2", :name => "three", :staged => false, :points => 2},
          %Card{:id => "fi2", :name => "five", :staged => false, :points => 4},
          %Card{:id => "q3", :name => "queen", :staged => false, :points => 11}
        ]
      },
      players: [
        "EBDA4E",
        "01D3CC",
        "ADDE47",
        "MXBZ22"
      ],
      active_player_id: "01D3CC"
    }

    # card 1
    new_state = Game.Engine.stage(state, "t1", "01D3CC")
    play_state = Game.Engine.play(new_state, "01D3CC")

    %Game.Engine{
      winner: winner,
      current: current,
      ranks: ranks,
      player_hands: player_hands,
      scores: scores,
      active_player_id: active_player_id
    } = play_state

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "01D3CC" end)

    [
      %Card{played: played_one},
      %Card{played: played_two},
      %Card{played: played_three}
    ] = cards

    assert played_one == true
    assert played_two == false
    assert played_three == false

    assert scores == %{"01D3CC" => 1}
    assert ranks == []
    assert active_player_id == "EBDA4E"
    [current_card] = current
    assert current_card.name == "two"
    assert winner == nil

    # card 2
    new_state = Game.Engine.stage(play_state, "th1", "EBDA4E")
    play_state = Game.Engine.play(new_state, "EBDA4E")

    %Game.Engine{
      winner: winner,
      current: current,
      ranks: ranks,
      player_hands: player_hands,
      scores: scores,
      active_player_id: active_player_id
    } = play_state

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "EBDA4E" end)

    [
      %Card{played: played_one},
      %Card{played: played_two},
      %Card{played: played_three}
    ] = cards

    assert played_one == true
    assert played_two == false
    assert played_three == false

    assert scores == %{"01D3CC" => 1, "EBDA4E" => 1}
    assert ranks == []
    assert active_player_id == "ADDE47"
    [current_card] = current
    assert current_card.name == "three"
    assert winner == nil

    # card 3
    new_state = Game.Engine.stage(play_state, "fo2", "ADDE47")
    play_state = Game.Engine.play(new_state, "ADDE47")

    %Game.Engine{
      winner: winner,
      current: current,
      ranks: ranks,
      player_hands: player_hands,
      scores: scores,
      active_player_id: active_player_id
    } = play_state

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "ADDE47" end)

    [
      %Card{played: played_one},
      %Card{played: played_two},
      %Card{played: played_three}
    ] = cards

    assert played_one == false
    assert played_two == true
    assert played_three == false

    assert scores == %{"01D3CC" => 1, "EBDA4E" => 1, "ADDE47" => 1}
    assert ranks == []
    assert active_player_id == "MXBZ22"
    [current_card] = current
    assert current_card.name == "four"
    assert winner == nil

    # card 4
    new_state = Game.Engine.stage(play_state, "fi2", "MXBZ22")
    play_state = Game.Engine.play(new_state, "MXBZ22")

    %Game.Engine{
      winner: winner,
      current: current,
      ranks: ranks,
      player_hands: player_hands,
      scores: scores,
      active_player_id: active_player_id
    } = play_state

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "MXBZ22" end)

    [
      %Card{played: played_one},
      %Card{played: played_two},
      %Card{played: played_three}
    ] = cards

    assert played_one == false
    assert played_two == true
    assert played_three == false

    assert scores == %{"01D3CC" => 1, "EBDA4E" => 1, "ADDE47" => 1, "MXBZ22" => 1}
    assert ranks == []
    assert active_player_id == "01D3CC"
    [current_card] = current
    assert current_card.name == "five"
    assert winner == nil

    # card 5
    new_state = Game.Engine.stage(play_state, "a1", "01D3CC")
    play_state = Game.Engine.play(new_state, "01D3CC")

    %Game.Engine{
      winner: winner,
      current: current,
      ranks: ranks,
      player_hands: player_hands,
      scores: scores,
      active_player_id: active_player_id
    } = play_state

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "01D3CC" end)

    [
      %Card{played: played_one},
      %Card{played: played_two},
      %Card{played: played_three}
    ] = cards

    assert played_one == true
    assert played_two == false
    assert played_three == true

    assert scores == %{"01D3CC" => 2, "EBDA4E" => 1, "ADDE47" => 1, "MXBZ22" => 1}
    assert ranks == []
    assert active_player_id == "01D3CC"
    assert Enum.count(current) == 0
    assert winner == nil

    # card 6
    new_state = Game.Engine.stage(play_state, "fo1", "01D3CC")
    play_state = Game.Engine.play(new_state, "01D3CC")

    %Game.Engine{
      winner: winner,
      current: current,
      ranks: ranks,
      player_hands: player_hands,
      scores: scores,
      active_player_id: active_player_id
    } = play_state

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "01D3CC" end)

    [
      %Card{played: played_one},
      %Card{played: played_two},
      %Card{played: played_three}
    ] = cards

    assert played_one == true
    assert played_two == true
    assert played_three == true

    assert scores == %{"01D3CC" => 3, "EBDA4E" => 1, "ADDE47" => 1, "MXBZ22" => 1}
    assert ranks == ["01D3CC"]
    assert active_player_id == "EBDA4E"
    [current_card] = current
    assert current_card.name == "four"
    assert winner == nil

    # card 7
    new_state = Game.Engine.stage(play_state, "q1", "EBDA4E")
    play_state = Game.Engine.play(new_state, "EBDA4E")

    %Game.Engine{
      winner: winner,
      current: current,
      ranks: ranks,
      player_hands: player_hands,
      scores: scores,
      active_player_id: active_player_id
    } = play_state

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "EBDA4E" end)

    [
      %Card{played: played_one},
      %Card{played: played_two},
      %Card{played: played_three}
    ] = cards

    assert played_one == true
    assert played_two == false
    assert played_three == true

    assert ranks == ["01D3CC"]
    assert scores == %{"01D3CC" => 3, "EBDA4E" => 2, "ADDE47" => 1, "MXBZ22" => 1}
    assert active_player_id == "ADDE47"
    [current_card] = current
    assert current_card.name == "queen"
    assert winner == nil

    # card 8
    new_state = Game.Engine.stage(play_state, "q2", "ADDE47")
    play_state = Game.Engine.play(new_state, "ADDE47")

    %Game.Engine{
      winner: winner,
      current: current,
      ranks: ranks,
      player_hands: player_hands,
      scores: scores,
      active_player_id: active_player_id
    } = play_state

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "ADDE47" end)

    [
      %Card{played: played_one},
      %Card{played: played_two},
      %Card{played: played_three}
    ] = cards

    assert played_one == false
    assert played_two == true
    assert played_three == true

    assert scores == %{"01D3CC" => 3, "EBDA4E" => 2, "ADDE47" => 2, "MXBZ22" => 1}
    assert ranks == ["01D3CC"]
    assert active_player_id == "EBDA4E"
    [current_card] = current
    assert current_card.name == "queen"
    assert winner == nil

    # skip turn -only has a five unplayed
    play_state = Game.Engine.skip_turn(play_state, "EBDA4E")

    %Game.Engine{
      winner: winner,
      current: current,
      ranks: ranks,
      scores: scores,
      active_player_id: active_player_id
    } = play_state

    assert scores == %{"01D3CC" => 3, "EBDA4E" => 2, "ADDE47" => 2, "MXBZ22" => 1}
    assert ranks == ["01D3CC"]
    assert active_player_id == "ADDE47"
    assert Enum.count(current) == 0
    assert winner == nil

    # card 9
    new_state = Game.Engine.stage(play_state, "t2", "ADDE47")
    play_state = Game.Engine.play(new_state, "ADDE47")

    %Game.Engine{
      winner: winner,
      current: current,
      ranks: ranks,
      player_hands: player_hands,
      scores: scores,
      active_player_id: active_player_id
    } = play_state

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "ADDE47" end)

    [
      %Card{played: played_one},
      %Card{played: played_two},
      %Card{played: played_three}
    ] = cards

    assert played_one == true
    assert played_two == true
    assert played_three == true

    assert ranks == ["01D3CC", "ADDE47"]
    assert scores == %{"01D3CC" => 3, "EBDA4E" => 2, "ADDE47" => 3, "MXBZ22" => 1}
    assert active_player_id == "MXBZ22"
    [current_card] = current
    assert current_card.name == "two"
    assert winner == nil

    # card 10 -split here- play the queen instead of the five
    new_state = Game.Engine.stage(play_state, "q3", "MXBZ22")
    play_state = Game.Engine.play(new_state, "MXBZ22")

    %Game.Engine{
      winner: winner,
      current: current,
      ranks: ranks,
      player_hands: player_hands,
      scores: scores,
      active_player_id: active_player_id
    } = play_state

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "MXBZ22" end)

    [
      %Card{played: played_one},
      %Card{played: played_two},
      %Card{played: played_three}
    ] = cards

    assert played_one == false
    assert played_two == true
    assert played_three == true

    assert ranks == ["01D3CC", "ADDE47"]
    assert scores == %{"01D3CC" => 3, "EBDA4E" => 2, "ADDE47" => 3, "MXBZ22" => 2}
    assert active_player_id == "EBDA4E"
    [current_card] = current
    assert current_card.name == "queen"
    assert winner == nil

    # skip turn -only has a ? unplayed
    play_state = Game.Engine.skip_turn(play_state, "EBDA4E")

    %Game.Engine{
      winner: winner,
      current: current,
      ranks: ranks,
      scores: scores,
      active_player_id: active_player_id
    } = play_state

    assert ranks == ["01D3CC", "ADDE47"]
    assert scores == %{"01D3CC" => 3, "EBDA4E" => 2, "ADDE47" => 3, "MXBZ22" => 2}
    assert active_player_id == "MXBZ22"
    assert Enum.count(current) == 0
    assert winner == nil

    # card 11
    new_state = Game.Engine.stage(play_state, "th2", "MXBZ22")
    play_state = Game.Engine.play(new_state, "MXBZ22")

    %Game.Engine{
      winner: winner,
      current: current,
      ranks: ranks,
      player_hands: player_hands,
      scores: scores,
      active_player_id: active_player_id
    } = play_state

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "MXBZ22" end)

    [
      %Card{played: played_one},
      %Card{played: played_two},
      %Card{played: played_three}
    ] = cards

    assert played_one == true
    assert played_two == true
    assert played_three == true

    assert ranks == ["01D3CC", "ADDE47", "MXBZ22"]
    assert scores == %{"01D3CC" => 3, "EBDA4E" => 2, "ADDE47" => 3, "MXBZ22" => 3}
    assert active_player_id == "MXBZ22"
    assert Enum.count(current) == 0
    assert winner == "01D3CC"
    # because the game is over we don't flip active player to next
    # and we clear the current

    restarted_state = Game.Engine.restart(play_state)

    %Game.Engine{
      winner: winner,
      current: current,
      ranks: ranks,
      scores: scores,
      players: players,
      active_player_id: active_player_id,
      order: order,
      player_hands: player_hands
    } = restarted_state

    assert ranks == []
    assert scores == %{}
    assert active_player_id == "01D3CC"
    assert Enum.count(current) == 0
    assert winner == nil

    assert order == [
             "01D3CC",
             "ADDE47",
             "MXBZ22",
             "EBDA4E"
           ]

    assert players == [
             "01D3CC",
             "ADDE47",
             "MXBZ22",
             "EBDA4E"
           ]

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "MXBZ22" end)
    assert Enum.count(cards) == 6

    [
      %Card{name: one},
      %Card{name: two},
      %Card{name: three},
      %Card{name: four},
      %Card{name: five},
      %Card{name: six}
    ] = cards

    assert one == "two"
    assert two == "two"
    assert three == "two"
    assert four == "two"
    assert five == "three"
    assert six == "queen"
    # assert six == "three"

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "ADDE47" end)
    assert Enum.count(cards) == 6

    [
      %Card{name: one},
      %Card{name: two},
      %Card{name: three},
      %Card{name: four},
      %Card{name: five},
      %Card{name: six}
    ] = cards

    assert one == "queen"
    # assert two == "queen"
    assert two == "ace"
    assert three == "ace"
    assert four == "ace"
    assert five == "ace"
    assert six == "three"
    # assert six == "ace"

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "ADDE47" end)
    assert Enum.count(cards) == 6

    [
      %Card{name: one},
      %Card{name: two},
      %Card{name: three},
      %Card{name: four},
      %Card{name: five},
      %Card{name: six}
    ] = cards

    assert one == "queen"
    # assert two == "queen"
    assert two == "ace"
    assert three == "ace"
    assert four == "ace"
    assert five == "ace"
    assert six == "three"
    # assert six == "ace"

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "EBDA4E" end)
    assert Enum.count(cards) == 6

    [
      %Card{name: one},
      %Card{name: two},
      %Card{name: three},
      %Card{name: four},
      %Card{name: five},
      %Card{name: six}
    ] = cards

    assert one == "three"
    assert two == "three"
    assert three == "four"
    assert four == "four"
    assert five == "four"
    assert six == "four"

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "01D3CC" end)
    assert Enum.count(cards) == 6

    [
      %Card{name: one},
      %Card{name: two},
      %Card{name: three},
      %Card{name: four},
      %Card{name: five},
      %Card{name: six}
    ] = cards

    assert one == "five"
    assert two == "five"
    assert three == "five"
    assert four == "five"
    assert five == "queen"
    assert six == "queen"
  end

  test "skip turn will unstage any staged cards for that player" do
    state = %Game.Engine{
      player_hands: %{
        "01D3CC" => [
          %Card{:id => "t1", :name => "two", :staged => false, :points => 1},
          %Card{:id => "t2", :name => "two", :staged => false, :points => 1},
          %Card{:id => "j1", :name => "jack", :staged => false, :points => 10},
          %Card{:id => "a1", :name => "ace", :staged => false, :points => 13}
        ],
        "EBDA4E" => [
          %Card{:id => "th1", :name => "three", :staged => false, :points => 2},
          %Card{:id => "th2", :name => "three", :staged => false, :points => 2},
          %Card{:id => "k1", :name => "king", :staged => false, :points => 12},
          %Card{:id => "q1", :name => "queen", :staged => false, :points => 11}
        ]
      },
      players: [
        "EBDA4E",
        "01D3CC"
      ],
      active_player_id: "01D3CC"
    }

    # stage the two
    new_state = Game.Engine.stage(state, "t1", "01D3CC")

    %Game.Engine{player_hands: player_hands, scores: scores} = new_state
    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "01D3CC" end)

    [
      %Card{staged: staged_one},
      %Card{staged: staged_two},
      %Card{staged: staged_three},
      %Card{staged: staged_four}
    ] = cards

    assert staged_one == true
    assert staged_two == false
    assert staged_three == false
    assert staged_four == false

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "EBDA4E" end)

    [
      %Card{staged: staged_player_two_one},
      %Card{staged: staged_player_two_two},
      %Card{staged: staged_player_two_three},
      %Card{staged: staged_player_two_four}
    ] = cards

    assert staged_player_two_one == false
    assert staged_player_two_two == false
    assert staged_player_two_three == false
    assert staged_player_two_four == false

    assert scores == %{}

    # now skip turn
    skipped_state = Game.Engine.skip_turn(new_state, "01D3CC")

    %Game.Engine{player_hands: player_hands, scores: scores} = skipped_state
    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "01D3CC" end)

    [
      %Card{id: staged_id_one, staged: staged_one},
      %Card{id: staged_id_two, staged: staged_two},
      %Card{id: staged_id_three, staged: staged_three},
      %Card{id: staged_id_four, staged: staged_four}
    ] = cards

    assert staged_id_one == "t1"
    assert staged_one == false
    assert staged_id_two == "t2"
    assert staged_two == false
    assert staged_id_three == "j1"
    assert staged_three == false
    assert staged_id_four == "a1"
    assert staged_four == false

    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == "EBDA4E" end)

    [
      %Card{staged: staged_player_two_one},
      %Card{staged: staged_player_two_two},
      %Card{staged: staged_player_two_three},
      %Card{staged: staged_player_two_four}
    ] = cards

    assert staged_player_two_one == false
    assert staged_player_two_two == false
    assert staged_player_two_three == false
    assert staged_player_two_four == false

    assert scores == %{}
  end

  test "winner removed from the current to unblock others" do
    state = %Game.Engine{
      player_hands: %{
        "01D3CC" => [
          %Card{:id => "k1", :name => "king", :staged => false, :points => 12},
          %Card{:id => "a1", :name => "ace", :staged => false, :points => 13}
        ],
        "EBDA4E" => [
          %Card{:id => "th1", :name => "three", :staged => false, :points => 2},
          %Card{:id => "q1", :name => "queen", :staged => false, :points => 11}
        ],
        "ADDE47" => [
          %Card{:id => "th2", :name => "three", :staged => false, :points => 2},
          %Card{:id => "q2", :name => "queen", :staged => false, :points => 11}
        ],
        "MXBZ22" => [
          %Card{:id => "th3", :name => "three", :staged => false, :points => 2},
          %Card{:id => "q3", :name => "queen", :staged => false, :points => 11}
        ]
      },
      players: [
        "EBDA4E",
        "01D3CC",
        "ADDE47",
        "MXBZ22"
      ],
      active_player_id: "01D3CC"
    }

    new_state = Game.Engine.stage(state, "a1", "01D3CC")
    play_state = Game.Engine.play(new_state, "01D3CC")

    %Game.Engine{
      winner: winner,
      players: players,
      active_player_id: active_player_id,
      current: current,
      current_player_id: current_player_id
    } = play_state

    assert Enum.count(players) == 4
    assert Enum.count(current) == 0
    assert active_player_id == "01D3CC"
    assert current_player_id == "01D3CC"
    assert winner == nil

    new_state = Game.Engine.stage(play_state, "k1", "01D3CC")
    play_state = Game.Engine.play(new_state, "01D3CC")

    %Game.Engine{
      winner: winner,
      players: players,
      active_player_id: active_player_id,
      current: current,
      current_player_id: current_player_id
    } = play_state

    assert Enum.count(players) == 4
    assert Enum.count(current) == 1
    [current_card] = current
    assert current_card.name == "king"
    assert active_player_id == "EBDA4E"
    assert current_player_id == "01D3CC"
    assert winner == nil

    skip_state = Game.Engine.skip_turn(play_state, "EBDA4E")

    %Game.Engine{
      winner: winner,
      players: players,
      active_player_id: active_player_id,
      current: current,
      current_player_id: current_player_id
    } = skip_state

    assert Enum.count(players) == 4
    assert Enum.count(current) == 1
    [current_card] = current
    assert current_card.name == "king"
    assert active_player_id == "ADDE47"
    assert current_player_id == "01D3CC"
    assert winner == nil

    skip_state = Game.Engine.skip_turn(skip_state, "ADDE47")

    %Game.Engine{
      winner: winner,
      players: players,
      active_player_id: active_player_id,
      current: current,
      current_player_id: current_player_id
    } = skip_state

    assert Enum.count(players) == 4
    assert Enum.count(current) == 1
    [current_card] = current
    assert current_card.name == "king"
    assert active_player_id == "MXBZ22"
    assert current_player_id == "01D3CC"
    assert winner == nil

    skip_state = Game.Engine.skip_turn(skip_state, "MXBZ22")

    %Game.Engine{
      winner: winner,
      players: players,
      active_player_id: active_player_id,
      current: current,
      current_player_id: current_player_id
    } = skip_state

    assert Enum.count(players) == 4
    assert Enum.count(current) == 0
    assert current_player_id == nil
    assert active_player_id == "EBDA4E"
    assert winner == nil
  end

  test "rotates around correctly when king played before ace" do
    state = %Game.Engine{
      player_hands: %{
        "01D3CC" => [
          %Card{:id => "k1", :name => "king", :staged => false, :points => 12},
          %Card{:id => "a1", :name => "ace", :staged => false, :points => 13}
        ],
        "EBDA4E" => [
          %Card{:id => "th1", :name => "three", :staged => false, :points => 2},
          %Card{:id => "q1", :name => "queen", :staged => false, :points => 11}
        ],
        "ADDE47" => [
          %Card{:id => "th2", :name => "three", :staged => false, :points => 2},
          %Card{:id => "q2", :name => "queen", :staged => false, :points => 11}
        ],
        "MXBZ22" => [
          %Card{:id => "th3", :name => "three", :staged => false, :points => 2},
          %Card{:id => "q3", :name => "queen", :staged => false, :points => 11}
        ]
      },
      players: [
        "EBDA4E",
        "01D3CC",
        "ADDE47",
        "MXBZ22"
      ],
      active_player_id: "01D3CC"
    }

    new_state = Game.Engine.stage(state, "k1", "01D3CC")
    play_state = Game.Engine.play(new_state, "01D3CC")

    %Game.Engine{
      winner: winner,
      players: players,
      active_player_id: active_player_id,
      current: current,
      current_player_id: current_player_id
    } = play_state

    assert Enum.count(players) == 4
    assert Enum.count(current) == 1
    [current_card] = current
    assert current_card.name == "king"
    assert active_player_id == "EBDA4E"
    assert current_player_id == "01D3CC"
    assert winner == nil

    skip_state = Game.Engine.skip_turn(play_state, "EBDA4E")

    %Game.Engine{
      winner: winner,
      players: players,
      active_player_id: active_player_id,
      current: current,
      current_player_id: current_player_id
    } = skip_state

    assert Enum.count(players) == 4
    assert Enum.count(current) == 1
    [current_card] = current
    assert current_card.name == "king"
    assert active_player_id == "ADDE47"
    assert current_player_id == "01D3CC"
    assert winner == nil

    skip_state = Game.Engine.skip_turn(skip_state, "ADDE47")

    %Game.Engine{
      winner: winner,
      players: players,
      active_player_id: active_player_id,
      current: current,
      current_player_id: current_player_id
    } = skip_state

    assert Enum.count(players) == 4
    assert Enum.count(current) == 1
    [current_card] = current
    assert current_card.name == "king"
    assert active_player_id == "MXBZ22"
    assert current_player_id == "01D3CC"
    assert winner == nil

    skip_state = Game.Engine.skip_turn(skip_state, "MXBZ22")

    %Game.Engine{
      winner: winner,
      players: players,
      active_player_id: active_player_id,
      current: current,
      current_player_id: current_player_id
    } = skip_state

    assert Enum.count(players) == 4
    assert Enum.count(current) == 0
    assert current_player_id == nil
    assert active_player_id == "01D3CC"
    assert winner == nil

    new_state = Game.Engine.stage(skip_state, "a1", "01D3CC")
    play_state = Game.Engine.play(new_state, "01D3CC")

    %Game.Engine{
      winner: winner,
      players: players,
      active_player_id: active_player_id,
      current: current,
      current_player_id: current_player_id
    } = play_state

    assert Enum.count(players) == 4
    assert Enum.count(current) == 0
    assert active_player_id == "EBDA4E"
    assert current_player_id == "01D3CC"
    assert winner == nil

    new_state = Game.Engine.stage(play_state, "q1", "EBDA4E")
    play_state = Game.Engine.play(new_state, "EBDA4E")

    %Game.Engine{
      winner: winner,
      players: players,
      active_player_id: active_player_id,
      current: current,
      current_player_id: current_player_id
    } = play_state

    assert Enum.count(players) == 4
    assert Enum.count(current) == 1
    [current_card] = current
    assert current_card.name == "queen"
    assert active_player_id == "ADDE47"
    assert current_player_id == "EBDA4E"
    assert winner == nil

    skip_state = Game.Engine.skip_turn(play_state, "ADDE47")

    %Game.Engine{
      winner: winner,
      players: players,
      active_player_id: active_player_id,
      current: current,
      current_player_id: current_player_id
    } = skip_state

    assert Enum.count(players) == 4
    assert Enum.count(current) == 1
    [current_card] = current
    assert current_card.name == "queen"
    assert active_player_id == "MXBZ22"
    assert current_player_id == "EBDA4E"
    assert winner == nil

    skip_state = Game.Engine.skip_turn(skip_state, "MXBZ22")

    %Game.Engine{
      winner: winner,
      players: players,
      active_player_id: active_player_id,
      current: current,
      current_player_id: current_player_id
    } = skip_state

    assert Enum.count(players) == 4
    assert Enum.count(current) == 0
    assert current_player_id == nil
    assert active_player_id == "EBDA4E"
    assert winner == nil

    new_state = Game.Engine.stage(skip_state, "th1", "EBDA4E")
    play_state = Game.Engine.play(new_state, "EBDA4E")

    %Game.Engine{
      winner: winner,
      players: players,
      active_player_id: active_player_id,
      current: current,
      current_player_id: current_player_id
    } = play_state

    assert Enum.count(players) == 4
    assert Enum.count(current) == 1
    [current_card] = current
    assert current_card.name == "three"
    assert active_player_id == "ADDE47"
    assert current_player_id == "EBDA4E"
    assert winner == nil

    skip_state = Game.Engine.skip_turn(play_state, "ADDE47")

    %Game.Engine{
      winner: winner,
      players: players,
      active_player_id: active_player_id,
      current: current,
      current_player_id: current_player_id
    } = skip_state

    assert Enum.count(players) == 4
    assert Enum.count(current) == 1
    [current_card] = current
    assert current_card.name == "three"
    assert active_player_id == "MXBZ22"
    assert current_player_id == "EBDA4E"
    assert winner == nil

    skip_state = Game.Engine.skip_turn(skip_state, "MXBZ22")

    %Game.Engine{
      winner: winner,
      players: players,
      active_player_id: active_player_id,
      current: current,
      current_player_id: current_player_id
    } = skip_state

    assert Enum.count(players) == 4
    assert Enum.count(current) == 0
    assert current_player_id == nil
    assert active_player_id == "ADDE47"
    assert winner == nil

    new_state = Game.Engine.stage(skip_state, "q2", "ADDE47")
    play_state = Game.Engine.play(new_state, "ADDE47")

    %Game.Engine{
      winner: winner,
      players: players,
      active_player_id: active_player_id,
      current: current,
      current_player_id: current_player_id
    } = play_state

    assert Enum.count(players) == 4
    assert Enum.count(current) == 1
    [current_card] = current
    assert current_card.name == "queen"
    assert active_player_id == "MXBZ22"
    assert current_player_id == "ADDE47"
    assert winner == nil

    new_state = Game.Engine.stage(play_state, "q3", "MXBZ22")
    play_state = Game.Engine.play(new_state, "MXBZ22")

    %Game.Engine{
      winner: winner,
      players: players,
      active_player_id: active_player_id,
      current: current,
      current_player_id: current_player_id
    } = play_state

    assert Enum.count(players) == 4
    assert Enum.count(current) == 0
    assert current_player_id == nil
    assert active_player_id == "MXBZ22"
    assert winner == nil

    new_state = Game.Engine.stage(play_state, "th3", "MXBZ22")
    play_state = Game.Engine.play(new_state, "MXBZ22")

    %Game.Engine{
      winner: winner,
      players: players,
      active_player_id: active_player_id,
      current: current,
      current_player_id: current_player_id
    } = play_state

    assert Enum.count(players) == 4
    assert Enum.count(current) == 0
    assert current_player_id == nil
    assert active_player_id == "MXBZ22"
    assert winner == "01D3CC"
  end
end
