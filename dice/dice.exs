ExUnit.start()

defmodule Dice do
  @spec run(Integer, Integer) :: String.t()
  def run(dice, sum) do
    count = combinations(dice) |> Enum.count(fn combo -> Enum.sum(combo) == sum end)
    "#{count} / #{:math.pow(6, dice) |> trunc}"
  end

  defp combinations(dice) do
    combinations(dice - 1, for(x <- 1..6, do: [x]))
  end

  defp combinations(0, acc), do: acc

  defp combinations(remaining_dice, acc) do
    combinations(
      remaining_dice - 1,
      for(
        x <- 1..6,
        y <- acc,
        do: [x | y]
      )
    )
  end
end

defmodule DiceTest do
  @moduledoc """
  Implement: @spec run(Integer, Integer) :: String.t

  The `run` function calculates the probability of rolling an expected sum
    with a given number of six-sided dice.

  The function should take two Integers:
    The first Integer is the number of six-sided dice
    The second Integer is the sum

  The function should return a String with the non-factored probability
    (e.g. "3 / 36" and not "1 / 12")

  Example: `2` dice have `36` possible combinations:
    1. [1][1]
    2. [1][2]
    3. [1][3]
    ...
    7. [2][1]
    8. [2][2]
    ...
    35. [5][6]
    36. [6][6]

   Of all these possible combinations, only `3` sum to `4`:
    1. [1][3] sum is `4`
    2. [3][1] sum is `4`
    3. [2][2] sum is `4`

  As such, `run(2, 4)` should return the String "3 / 36"`
  """
  use ExUnit.Case
  import Dice

  test "Dice.run" do
    # [1]
    assert run(1, 1) == "1 / 6"

    # [2]
    assert run(1, 2) == "1 / 6"

    # [3]
    assert run(1, 3) == "1 / 6"

    # [1][1]
    assert run(2, 2) == "1 / 36"

    # [1][2], [2][1]
    assert run(2, 3) == "2 / 36"

    # [1][3], [2][2], [3][1]
    assert run(2, 4) == "3 / 36"

    # [1][4], [2][3], [3][2], [4][1]
    assert run(2, 5) == "4 / 36"

    # [1][5], [2][4], [3][3], [4][2], [5][1]
    assert run(2, 6) == "5 / 36"

    # [1][1][3], [1][3][1], [3][1][1],
    # [1][2][2], [2][1][2], [2][2][1]
    assert run(3, 5) == "6 / 216"

    # [2][2][2],
    # [1][2][3], [1][3][2],
    # [2][1][3], [2][3][1],
    # [3][1][2], [3][2][1],
    # [1][1][4], [1][4][1], [4][1][1]
    assert run(3, 6) == "10 / 216"

    # unable to roll 15 on 1 six-sided die
    assert run(1, 15) == "0 / 6"

    # unable to roll 1 when 3 six-sided die are rolled, as lowest number is 3
    assert run(3, 1) == "0 / 216"
  end
end
