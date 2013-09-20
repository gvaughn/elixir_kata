defmodule Poker do

  def winner(hands_binary) do
    {hand1, hand2} = Poker.Hand.pair_from_string(hands_binary)
    #IO.inspect hand1
    #IO.inspect hand2
    Enum.max_by([hand1, hand2], fn(hand) -> hand.power end).player
  end

  def euler_calculation do
    {:ok, file} = File.open "poker.txt"
    win_list = Enum.reduce(IO.stream(file, :line), [], fn(line, accum) -> [winner(line) | accum] end)
    {p1_wins, p2_wins} = Enum.partition(win_list, &1 == 1)
    IO.puts "Player 1 wins #{Enum.count(p1_wins)} times"
    IO.puts "Player 2 wins #{Enum.count(p2_wins)} times"
  end
end
