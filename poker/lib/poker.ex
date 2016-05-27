defmodule Poker do

  def winner(hands_binary) do
    Poker.Hand.pair_from_string(hands_binary)
    |> Enum.max_by(fn(hand) -> hand.power end)
  end

  def euler_calculation do
    {p1_wins, p2_wins} =
    File.stream!("poker.txt")
    |> Enum.map(&winner/1)
    |> Enum.partition(&(&1.player == 1))

    IO.puts "Player 1 wins #{Enum.count(p1_wins)} times"
    IO.puts "Player 2 wins #{Enum.count(p2_wins)} times"
  end
end
