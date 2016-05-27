defmodule Poker.Hand do
  alias Poker.Card
  defstruct player: 0, type: "", cards: [], power: 0

  def from_string(str) do
    pair_from_string(str) |> List.first
  end

  def pair_from_string(card_str) do
    card_str
    |> String.split
    |> Enum.map(&Card.from_string/1)
    |> Enum.chunk(5)
    |> Enum.zip([1,2])
    |> Enum.map(fn {cards, player} ->
      {type, power} = stats(cards)
      %__MODULE__{player: player, type: type, cards: cards, power: power}
    end)
  end

  defp stats(cards) do
    {card_freq, suit_freq, gaps} = raw_stats(cards)
    tiebreakers = card_freq
      |> Enum.sort(fn({ka, va}, {kb, vb}) -> {va, ka} > {vb, kb} end)
      |> Enum.map(fn({card, _count}) -> card end)
    {straight, tiebreakers} = is_straight?(gaps, tiebreakers)

    face_arity = Enum.count(card_freq)
    max_face_freq = card_freq |> Map.values |> Enum.max
    suit_arity = Enum.count(suit_freq)

    determine_type(face_arity, max_face_freq, suit_arity, straight, tiebreakers)
  end

  defp raw_stats(cards) do
    {card_freq, suit_freq} = Enum.reduce(cards, {%{}, %{}}, &frequencies/2)

    sorted_cards = Enum.sort_by(cards, &Card.value/1, &>/2)
    gaps =
    sorted_cards
    |> Enum.chunk(2, 1)
    |> Enum.map(fn([a,b]) -> Card.value(a) - Card.value(b) end)

    {card_freq, suit_freq, gaps}
  end

  defp is_straight?([1,1,1,1], card_freq), do: {true, [List.first(card_freq)]}
  defp is_straight?([9,1,1,1], _card_freq), do: {true, [5]} #ace low straight
  defp is_straight?(_, card_freq),         do: {false, card_freq}

  defp frequencies(card, {face_map, suit_map}) do
    {
      Map.update(face_map, Card.value(card), 1, &(&1 + 1)),
      Map.update(suit_map, card.suit, 1, &(&1 + 1))
    }
  end

  defp determine_type(face_arity, max_face_freq, suit_arity, straight, tiebreakers) do
    {type, leading_term}  = cond do
      straight and suit_arity == 1           -> {"straight flush", 8}
      face_arity == 2 and max_face_freq == 4 -> {"quads", 7}
      face_arity == 2 and max_face_freq == 3 -> {"full house", 6}
      suit_arity == 1                        -> {"flush", 5}
      straight                               -> {"straight", 4}
      face_arity == 3 and max_face_freq == 3 -> {"trips", 3}
      face_arity == 3 and max_face_freq == 2 -> {"2 pair", 2}
      face_arity == 4                        -> {"pair", 1}
      face_arity == 5                        -> {"high card", 0}
    end
    {type, calc_power([leading_term | tiebreakers])}
  end

  defp calc_power(digits) do
    Enum.zip(digits, 5..0)
    |> Enum.reduce(0, fn({term, exponent}, sum) ->
      sum + :erlang.trunc(term * :math.pow(15, exponent))
    end)
  end
end
