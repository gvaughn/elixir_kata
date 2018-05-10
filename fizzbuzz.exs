# original Haskell

# fizzes = cycle ["", "", "Fizz"]
# buzzes = cycle ["", "", "", "", "Buzz"]
# words = zipWith (++) fizzes buzzes
# numbers = map show [1..]
# choice = max
# fizzbuzz = zipWith choice words numbers

# import Stream, only: [cycle: 1, map: 2, zip: 2, with_index: 2]
#
# chooser = fn
#   {{nil, nil}, n} -> n
#   {{f, b}, _} -> "#{f}#{b}"
# end

# fizzbuzz =
#   cycle([nil, nil, "Fizz"])
#   |> zip(cycle([nil, nil, nil, nil, "Buzz"]))
#   |> with_index(1)
#   |> map(chooser)

import Stream, only: [cycle: 1, map: 2, zip: 2, iterate: 2]
import Tuple, only: [to_list: 1]
import Enum, only: [join: 1, max: 1]

fizzes = cycle([nil, nil, "Fizz"])
buzzes = cycle([nil, nil, nil, nil, "Buzz"])
words = zip(fizzes, buzzes) |> map(&join(to_list(&1)))
numbers = iterate(1, &Kernel.+(&1, 1)) |> map(&to_string/1)
fizzbuzz = zip(words, numbers) |> map(&max(to_list(&1)))

fizzbuzz |> Enum.take(30) |> IO.inspect()
