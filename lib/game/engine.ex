defmodule Game.Engine do
  defstruct playing_cards: [],
            player_hands: %{},
            cards: [],
            ranks: [],
            order: [],
            active_player_id: nil,
            players: [],
            scores: %{},
            random: nil,
            game_name: nil,
            started_at: nil,
            current: [],
            current_player_id: nil,
            winner: nil,
            skipped: 0

  alias Game.Card
  alias Game.Hash
  alias __MODULE__

  def new(game_name, playing_cards, random) do
    cards =
      playing_cards
      |> generate_cards(random)

    %Engine{
      game_name: game_name,
      cards: cards,
      playing_cards: playing_cards,
      random: random
    }
  end

  def leave(%Engine{players: players, active_player_id: active_player_id} = game, player_id) do
    new_players = Enum.filter(players, fn p -> p !== player_id end)

    active =
      case active_player_id == player_id do
        true ->
          case Enum.take(new_players, 1) do
            [next_player] -> next_player
            [] -> nil
          end

        false ->
          active_player_id
      end

    %{game | players: new_players, active_player_id: active}
  end

  def join(
        %Engine{started_at: started_at, players: players, player_hands: player_hands} = game,
        player_id
      ) do
    case not is_nil(started_at) || (Enum.count(players) == 8 && !Enum.member?(players, player_id)) do
      true ->
        player_ids = player_hands |> Map.keys()

        if player_id in player_ids do
          new_game = join_game(game, player_id)
          {:ok, new_game}
        else
          {:error, "join failed: game was full or started"}
        end

      false ->
        new_game = join_game(game, player_id)
        {:ok, new_game}
    end
  end

  defp unstage_all(
         %Engine{player_hands: player_hands, active_player_id: active_player_id} = game,
         player_id
       ) do
    if player_id != active_player_id do
      game
    else
      {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == player_id end)

      new_hand =
        cards
        |> Enum.map(&unstage_all_cards(&1))

      new_player_hands = player_hands |> Map.put(player_id, new_hand)

      %{game | player_hands: new_player_hands}
    end
  end

  defp clear_current(
         %Engine{
           ranks: ranks,
           winner: winner,
           skipped: skipped,
           players: players,
           active_player_id: active_player_id,
           current_player_id: current_player_id
         } = game,
         ace_played?,
         skip_turn?
       ) do
    if ace_played? do
      if is_nil(winner) do
        %{game | current: []}
      else
        game
      end
    else
      active_players = Enum.filter(players, fn p -> p not in ranks end)
      playerz = Enum.count(active_players)

      cond do
        current_player_id == active_player_id ->
          %{game | current: [], current_player_id: nil}

        skip_turn? && skipped >= playerz ->
          %{game | current: [], current_player_id: nil}

        true ->
          game
      end
    end
  end

  defp maybe_skip_next(
         %Engine{winner: winner, active_player_id: active_player_id} = game,
         even_scores?,
         ace_played?
       ) do
    cond do
      winner ->
        game

      ace_played? ->
        game

      even_scores? ->
        skip(game, active_player_id, false)

      true ->
        game
    end
  end

  def skip_turn(%Engine{} = game, player_id) do
    ace_played? = false

    game
    |> unstage_all(player_id)
    |> skip(player_id, ace_played?)
    |> increment_skipped()
    |> clear_current(ace_played?, true)
  end

  defp increment_skipped(%Engine{skipped: skipped} = game) do
    new_skipped = skipped + 1
    %{game | skipped: new_skipped}
  end

  defp reset_skipped(%Engine{} = game) do
    %{game | skipped: 0}
  end

  def skip(
        %Engine{
          winner: winner,
          ranks: ranks,
          players: players,
          active_player_id: active_player_id
        } = game,
        player_id,
        ace_played?
      ) do
    if not is_nil(winner) || player_id != active_player_id do
      game
    else
      if ace_played? && active_player_id not in ranks do
        game
      else
        exclude_active_player =
          Enum.filter(players, fn p -> p !== active_player_id && p not in ranks end)

        next_player =
          case Enum.count(exclude_active_player) == 0 do
            true ->
              active_player_id

            false ->
              [next] = Enum.take(exclude_active_player, 1)
              next
          end

        new_playerz = exclude_active_player ++ [active_player_id] ++ ranks
        new_players = new_playerz |> Enum.uniq()

        %{game | active_player_id: next_player, players: new_players}
      end
    end
  end

  def play(
        %Engine{current: current, player_hands: player_hands, active_player_id: active_player_id} =
          game,
        player_id
      ) do
    if player_id != active_player_id do
      game
    else
      {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == active_player_id end)

      current_card = current |> List.first()
      staged_cards = cards |> Enum.filter(fn card -> card.staged == true end)
      staged = staged_cards |> List.first()

      cond do
        not is_nil(staged) && is_nil(current_card) ->
          play_and_score(game, player_id)

        not is_nil(staged) && staged_gte_current?(current, staged_cards) ->
          play_and_score(game, player_id)

        true ->
          game
      end
    end
  end

  defp staged_gte_current?(current, staged_cards) do
    current_count = Enum.count(current)
    staged_count = Enum.count(staged_cards)
    staged = staged_cards |> List.first()

    cond do
      current_count == staged_count ->
        current_card = current |> List.first()
        staged = staged_cards |> List.first()
        staged.points >= current_card.points

      staged_count > current_count ->
        # 2 queens should be 1 king
        true

      staged.name == "ace" ->
        # 1 ace should be 3 kings
        true

      true ->
        false
    end
  end

  defp staged_card_was_ace?(%Engine{
         player_hands: player_hands,
         active_player_id: active_player_id
       }) do
    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == active_player_id end)

    staged_cards = cards |> Enum.filter(fn card -> card.staged == true end)
    staged = staged_cards |> List.first()

    staged && staged.name == "ace"
  end

  defp scores_are_equal?(%Engine{
         current: current,
         player_hands: player_hands,
         active_player_id: active_player_id
       }) do
    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == active_player_id end)

    current_card = current |> List.first()
    staged_cards = cards |> Enum.filter(fn card -> card.staged == true end)
    staged = staged_cards |> List.first()

    cond do
      not is_nil(staged) && is_nil(current_card) ->
        false

      not is_nil(staged) && staged.points == current_card.points ->
        current_count = Enum.count(current)
        staged_count = Enum.count(staged_cards)

        if staged_count == current_count do
          true
        else
          false
        end

      true ->
        false
    end
  end

  defp play_and_score(
         %Engine{player_hands: player_hands, active_player_id: active_player_id} = game,
         player_id
       ) do
    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == active_player_id end)

    new_hand =
      cards
      |> Enum.map(&play_card(&1))

    new_player_hands = player_hands |> Map.put(active_player_id, new_hand)

    even_scores? = scores_are_equal?(game)
    ace_played? = staged_card_was_ace?(game)

    %{game | player_hands: new_player_hands}
    |> calculate_scores()
    |> track_ranks()
    |> declare_winners()
    |> skip(player_id, ace_played?)
    |> maybe_skip_next(even_scores?, ace_played?)
    |> reset_skipped()
    |> clear_current(ace_played?, false)
  end

  defp declare_winners(%Engine{ranks: ranks, players: players} = game) do
    ranked =
      players
      |> Enum.reduce(0, fn player, acc ->
        if player in ranks do
          acc + 1
        else
          acc
        end
      end)

    total = Enum.count(players) - 1

    if ranked >= total do
      player_id = ranks |> List.first()
      %{game | winner: player_id}
    else
      game
    end
  end

  defp calculate_scores(
         %Engine{player_hands: player_hands, scores: scores, active_player_id: active_player_id} =
           game
       ) do
    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == active_player_id end)

    new_scores =
      case Enum.count(cards, fn card -> card.score == true end) > 0 do
        true ->
          score = Map.get(scores, active_player_id, 0) + 1
          Map.put(scores, active_player_id, score)

        false ->
          scores
      end

    current = cards |> Enum.filter(fn card -> card.score == true end)

    unscored = cards |> Enum.map(fn card -> %Card{card | score: false} end)
    new_player_hands = player_hands |> Map.put(active_player_id, unscored)

    %{
      game
      | current: current,
        current_player_id: active_player_id,
        scores: new_scores,
        player_hands: new_player_hands
    }
  end

  defp track_ranks(game) do
    %Engine{ranks: ranks, active_player_id: active_player_id, player_hands: player_hands} = game
    {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == active_player_id end)

    total = Enum.count(cards)
    played = Enum.count(cards, fn card -> card.played == true end)

    case total == played do
      true ->
        new_ranks = ranks ++ [active_player_id]
        %{game | ranks: new_ranks}

      false ->
        game
    end
  end

  def stage(
        %Engine{player_hands: player_hands, active_player_id: active_player_id} = game,
        card_id,
        player_id
      ) do
    if player_id != active_player_id do
      game
    else
      {_, cards} = player_hands |> Enum.find(fn {k, _} -> k == player_id end)
      %Card{name: card_name} = cards |> Enum.find(fn card -> card.id == card_id end)

      new_hand =
        cards
        |> Enum.map(&unstage_cards(&1, card_name))
        |> Enum.map(&stage_card(&1, card_id))

      new_player_hands = player_hands |> Map.put(player_id, new_hand)

      %{game | player_hands: new_player_hands}
    end
  end

  defp play_card(card) do
    case card.staged == true do
      true -> %Card{card | played: true, staged: false, score: true}
      false -> card
    end
  end

  defp unstage_cards(card, name) do
    case card.name != name do
      true -> %Card{card | staged: false}
      false -> card
    end
  end

  defp unstage_all_cards(card) do
    %Card{card | staged: false}
  end

  defp stage_card(card, id) do
    case card.id == id && card.played == false do
      true -> %Card{card | staged: true}
      false -> card
    end
  end

  defp join_game(%Engine{players: players, active_player_id: active_player_id} = game, player_id) do
    active =
      case active_player_id == nil do
        true ->
          player_id

        false ->
          active_player_id
      end

    new_players =
      case player_id in players do
        true -> players
        false -> [player_id | players]
      end

    %{game | players: new_players, active_player_id: active}
  end

  def generate_cards(cards, random) do
    length = 8
    total = Enum.count(cards)

    resulting_cards =
      cards
      |> Enum.with_index()
      |> Enum.map(fn {name, index} ->
        points = index + 1
        hash = Hash.hmac("type:card", name, length)

        one = %Card{
          id: "#{hash}1",
          name: name,
          image: "/images/cards/one/#{name}_one@2x.png",
          points: points
        }

        two = %Card{
          id: "#{hash}2",
          name: name,
          image: "/images/cards/two/#{name}_two@2x.png",
          points: points
        }

        three = %Card{
          id: "#{hash}3",
          name: name,
          image: "/images/cards/three/#{name}_three@2x.png",
          points: points
        }

        four = %Card{
          id: "#{hash}4",
          name: name,
          image: "/images/cards/four/#{name}_four@2x.png",
          points: points
        }

        [one, two, three, four]
      end)
      |> List.flatten()

    if random == true do
      resulting_cards
      |> Enum.take_random(total * 4)
    else
      resulting_cards
      |> Enum.take(total * 4)
    end
  end

  def started(%Engine{players: players, cards: cards, started_at: nil} = game, swap?) do
    now = NaiveDateTime.local_now()
    count = Enum.count(cards)
    total = Enum.count(players)
    hand_size = trunc(count / total)

    player_hands =
      players
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {player, index}, acc ->
        next = index * hand_size
        hand = cards |> Enum.slice(next, hand_size)
        acc |> Map.put(player, hand)
      end)

    # random President, VP and scum
    order = players |> Enum.take_random(total)

    player_hands =
      if swap? == true do
        player_hands |> swap_player_cards(order)
      else
        player_hands
      end

    %{game | started_at: now, player_hands: player_hands, order: order, players: order}
  end

  def started(%Engine{} = game, _swap?), do: game

  def restart(%Engine{
        ranks: ranks,
        game_name: game_name,
        playing_cards: playing_cards,
        random: random,
        players: players,
        started_at: started_at
      }) do
    game =
      game_name
      |> Engine.new(playing_cards, random)
      |> Map.put(:players, players)
      |> Engine.started(false)

    order =
      if Enum.count(players) > Enum.count(ranks) do
        biggest_loser = Enum.filter(players, fn p -> p not in ranks end)
        ranks ++ biggest_loser
      else
        ranks
      end

    active_player_id = order |> List.first()

    player_hands = game.player_hands |> swap_player_cards(order)

    %{
      game
      | active_player_id: active_player_id,
        started_at: started_at,
        order: order,
        players: order,
        player_hands: player_hands
    }
  end

  def swap_cards(royal_hand, scum_hand) do
    high_card =
      scum_hand
      |> Enum.max_by(& &1.points)

    low_card =
      royal_hand
      |> Enum.min_by(& &1.points)

    new_royal_hand =
      royal_hand
      |> Enum.reject(&(&1.id == low_card.id))

    new_scum_hand =
      scum_hand
      |> Enum.reject(&(&1.id == high_card.id))

    final_royal_hand = new_royal_hand ++ [high_card]
    final_scum_hand = new_scum_hand ++ [low_card]

    %{
      scum_hand: final_scum_hand,
      royal_hand: final_royal_hand
    }
  end

  def swap_player_cards(player_hands, order) do
    cond do
      Enum.count(order) == 3 ->
        president = order |> Enum.at(0)
        {_, president_cards} = player_hands |> Enum.find(fn {k, _} -> k == president end)
        lowest_scum = order |> Enum.at(-1)
        {_, lowest_scum_cards} = player_hands |> Enum.find(fn {k, _} -> k == lowest_scum end)

        %{
          scum_hand: the_scum_hand,
          royal_hand: the_royal_hand
        } = swap_cards(president_cards, lowest_scum_cards)

        player_hands
        |> Map.put(president, the_royal_hand)
        |> Map.put(lowest_scum, the_scum_hand)

      Enum.count(order) > 3 ->
        president = order |> Enum.at(0)
        {_, president_cards} = player_hands |> Enum.find(fn {k, _} -> k == president end)
        lowest_scum = order |> Enum.at(-1)
        {_, lowest_scum_cards} = player_hands |> Enum.find(fn {k, _} -> k == lowest_scum end)

        vice = order |> Enum.at(1)
        {_, vice_cards} = player_hands |> Enum.find(fn {k, _} -> k == vice end)
        scum = order |> Enum.at(-2)
        {_, scum_cards} = player_hands |> Enum.find(fn {k, _} -> k == scum end)

        %{
          scum_hand: the_scum_hand,
          royal_hand: the_royal_hand
        } = swap_cards(president_cards, lowest_scum_cards)

        %{
          scum_hand: final_low_scum_hand,
          royal_hand: final_prez_hand
        } = swap_cards(the_royal_hand, the_scum_hand)

        player_hands
        |> Map.put(president, final_prez_hand)
        |> Map.put(lowest_scum, final_low_scum_hand)

        %{
          scum_hand: new_scum_hand,
          royal_hand: new_royal_hand
        } = swap_cards(vice_cards, scum_cards)

        player_hands
        |> Map.put(vice, new_royal_hand)
        |> Map.put(scum, new_scum_hand)

      true ->
        player_hands
    end
  end
end
