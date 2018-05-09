import Stream, only: [cycle: 1, map: 2, zip: 2, with_index: 2]

chooser = fn
  {{nil, nil}, n} -> n
  {{f, b}, _} -> "#{f}#{b}"
end

fizzbuzz =
  cycle([nil, nil, "Fizz"])
  |> zip(cycle([nil, nil, nil, nil, "Buzz"]))
  |> with_index(1)
  |> map(chooser)

fizzbuzz |> Enum.take(30) |> IO.inspect()
