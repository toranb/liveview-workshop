defmodule Game.Generator do
  def icon do
    Enum.random(numbers())
  end

  def username do
    [
      Enum.random(adjectives()),
      Enum.random(animals())
    ]
    |> Enum.join(" ")
  end

  def haiku do
    [
      Enum.random(foods()),
      :rand.uniform(9999)
    ]
    |> Enum.join("-")
  end

  def foods do
    ~w(
      apple banana orange
      grape kiwi mango
      pear pineapple strawberry
      tomato watermelon cantaloupe
    )
  end

  def adjectives do
    ~w(
      frozen golden galactic
      hungry speedy brilliant
      brave bold delirious
      focused puzzled quirky
      intelligent demanding bright
    )
  end

  def animals do
    ~w(
      yeti camel fish
      cat dinosaur dragon
      frog griffin drone
      hydra juggernaut lizard
      ninja octopus ooze rhino
      scarecrow scorpion wolf
    )
  end

  def numbers do
    ~w(
      four five six
      seven eight nine
      ten eleven twelve
      thirteen fourteen fifteen
      sixteen seventeen eighteen
    )
  end
end
