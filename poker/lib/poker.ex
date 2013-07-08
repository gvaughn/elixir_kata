defmodule Poker do

  def winner(hands_binary) do
    {hand1, hand2} = Poker.Hand.pair_from_string(hands_binary)
  end
end
