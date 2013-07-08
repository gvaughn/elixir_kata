Code.require_file "test_helper.exs", __DIR__

defmodule PokerTest do
  use ExUnit.Case

  @hands [
    {"straight flush",  "TH 9H 8H 7H 6H"},
    {"quads",           "4H 4C 4D 4S JC"},
    {"full house",      "4H 4C 4D 3S 3C"},
    {"flush",           "4H 5H 6H TH 8H"},
    {"straight",        "4H 5H 6D 7S 8C"},
    {"trips",           "4H 4C 4D 2H JC"},
    {"2 pair",          "2H 2S 3C 3S 4D"},
    {"pair",            "2H 2S 5C 7D AH"},
    {"high card",       "2H 4C 6S 8D TH"}
  ]

  test "recognizes types" do
    Enum.each(@hands, fn({type, str}) ->
      assert Poker.Hand.from_string(str).type == type
    end)
  end

  test "recognizes ace-low straight" do
    assert Poker.Hand.from_string("AH 2C 3D 4H 5S").type == "straight"
  end

  test "comparisons" do
    _comparisons(@hands)
  end

  def _comparisons([]), do: nil
  def _comparisons([{_, winner_str} | losers]) do
    Enum.each(losers, fn({_, str}) ->
      assert Poker.Hand.from_string(winner_str).power > Poker.Hand.from_string(str).power
    end)
    _comparisons(losers)
  end

  test "ace-low straight loses to other straight" do
    assert Poker.Hand.from_string("4H 5C 6D 7S 8C").power >
            Poker.Hand.from_string("AH 2C 3D 4H 5S").power
  end

  test "using tiebreakers pair of 3s beat a pair of 2s" do
    assert Poker.winner("3C 3H 5C 7D 9S 2C 2H 5S 7C AH") == 1
  end

  test "using tiebreakers ace-high beats king-high" do
    assert Poker.winner("AC 2H 4C 6D 8S KH 2C 4H 6C 8H") == 1
  end

  test "using tiebreakers pairs use kicker" do
    assert Poker.winner("8H 8S AC 2S 3D 8C 8D KD 9S 2C") == 1
  end
end
