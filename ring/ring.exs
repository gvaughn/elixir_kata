defmodule Ring do

  def play(num_players) do
    _play(0..num_players)
  end

  defp _play([winner]), do: winner
  defp _play([winner, _loser]), do: winner
  defp _play([_loser1, winner, _loser2]), do: winner
  defp _play(players) do
    survivors = players
    |> Stream.chunk(3, 3, [])
    |> Enum.flat_map(fn triple -> Stream.drop(triple, 1) end)

    _play([0| survivors])
  end
end

ExUnit.start

defmodule RingTest do
  use ExUnit.Case

  test "does sample" do
    assert 1 == Ring.play(6)
  end
end

