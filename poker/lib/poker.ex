defmodule Poker do

  def winner(hands_binary) do
    {hand1, hand2} = Poker.Hand.pair_from_string(hands_binary)
    #IO.inspect hand1
    #IO.inspect hand2
    Enum.max([hand1, hand2], fn(hand) -> hand.power end).player
  end

  def euler_calculation do
    {:ok, file} = File.open "poker.txt"
    win_list = readline(IO.readline(file), file, [])
    {p1_wins, p2_wins} = Enum.partition(win_list, &1 == 1)
    IO.puts "Player 1 wins #{Enum.count(p1_wins)} times"
    IO.puts "Player 2 wins #{Enum.count(p2_wins)} times"
  end

  def readline(:eof, _, win_list), do: win_list
  def readline(line, file, win_list) when is_binary(line) do
    readline(IO.readline(file), file, [winner(line) | win_list])
  end
end
