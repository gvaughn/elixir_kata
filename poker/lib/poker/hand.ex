defrecord Poker.Hand, player: 0, type: "", cards: [], power: 0 do

  def from_string(str) do
    #TODO remove duplication with pair_from_string
    cards = str
      |> String.split
      |> Enum.map &Poker.Card.from_string/1
    {type, power} = stats(cards)
    Poker.Hand.new(player: 0, type: type, cards: cards, power: power)
  end

  def pair_from_string(str) do
    cards = str
      |> String.split
      |> Enum.map &Poker.Card.from_string/1

    {p1_cards, p2_cards} = Enum.split(cards, 5)
    {p1_type, p1_power} = stats(p1_cards)
    {p2_type, p2_power} = stats(p2_cards)

    {Poker.Hand.new(player: 1, type: p1_type, cards: p1_cards, power: p1_power),
     Poker.Hand.new(player: 2, type: p2_type, cards: p2_cards, power: p2_power)}
  end

  defp stats(cards) do
    {card_freq, suit_freq, gaps} = raw_stats(cards)
    tiebreakers = card_freq
      |> Enum.sort(fn({ka, va}, {kb, vb}) -> {va, ka} > {vb, kb} end)
      |> Enum.map(fn({card, count}) -> card end)
    {straight, tiebreakers} = is_straight?(gaps, tiebreakers)

    face_arity = Enum.count(card_freq)
    max_face_freq = card_freq |> Dict.values |> Enum.max
    suit_arity = Enum.count(suit_freq)

    determine_type(face_arity, max_face_freq, suit_arity, straight, tiebreakers)
  end

  defp raw_stats(cards) do
    {card_freq, suit_freq} = cards
      |> Enum.reduce({ListDict.new, HashDict.new}, &Poker.Hand.frequencies/2)

    sorted_cards = cards |> Enum.sort(fn(a,b) -> a.value > b.value end)
    gaps = each_cons(sorted_cards) |> Enum.map(fn([a,b]) -> a.value - b.value end)

    {card_freq, suit_freq, gaps}
  end

  defp is_straight?([1,1,1,1], card_freq), do: {true, [Enum.first(card_freq)]}
  defp is_straight?([9,1,1,1], card_freq), do: {true, [5]} #ace low straight
  defp is_straight?(_, card_freq),         do: {false, card_freq}

  def frequencies(card, {face_hash, suit_hash}) do
    {Dict.update(face_hash, card.value, 1, &1 + 1),
     Dict.update(suit_hash, card.suit,  1, &1 + 1)}
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
    |> Enum.reduce(0, fn({term, exponent}, sum) -> sum +
                          :erlang.trunc(term * :math.pow(15, exponent)) end)
  end

  defp each_cons(list, n // 2), do: _each_cons(list, n, [])

  defp _each_cons(list, n, result) when length(list) < 2, do: Enum.reverse(result)

  defp _each_cons(list = [_ | tail], n, result) do
    _each_cons(tail, n, [Enum.take(list, n) | result])
  end
end
