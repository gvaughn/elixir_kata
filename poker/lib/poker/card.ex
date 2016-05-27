defmodule Poker.Card do
  defstruct face: "", suit: ""

  def value(record) do
    case record.face do
      "A" -> 14
      "K" -> 13
      "Q" -> 12
      "J" -> 11
      "T" -> 10
      num -> String.to_integer(num)
    end
  end

  def from_string(<< value :: utf8, suit :: utf8 >>)
  when suit in [?C, ?D, ?H, ?S] and ((value in ?2..?9) or (value in [?A, ?K, ?Q, ?J, ?T])) do
    %__MODULE__{face: <<value>>, suit: <<suit>>}
  end
end
