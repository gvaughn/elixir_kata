defmodule Poker do

  def winner(hands_binary) do
    {hand1, hand2} = Poker.Hand.pair_from_string(hands_binary)
    #IO.inspect hand1
    #IO.inspect hand2
    Enum.max([hand1, hand2], fn(hand) -> hand.power end).player
  end
end
