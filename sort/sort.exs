ExUnit.start()

defmodule Sort do
  @spec run([Integer]) :: [Integer]
  def run([]), do: []

  def run(list) do
    Enum.reduce(list, [], fn element, acc -> sort_one([], element, acc) end)
  end

  # we've reached end of comparisons so candidate goes last
  defp sort_one(left, candidate, []) do
    Enum.concat(left, [candidate])
  end

  # found place to insert candidate
  defp sort_one(left, candidate, [compare_to | _rest] = right) when candidate <= compare_to do
    Enum.concat([left, [candidate], right])
  end

  # shift compare_to from right to left and recurse
  defp sort_one(left, candidate, [compare_to | rest]) do
    sort_one(left ++ [compare_to], candidate, rest)
  end
end

defmodule SortTest do
  @moduledoc """
  Implement: @spec run([Integer]) :: [Integer]

  The `run` function should take a one dimensional List of Integers,
  and return a List of Integers sorted by their numerican value.
  """
  use ExUnit.Case
  import Sort

  test "Sort.run" do
    assert run([]) == []
    assert run([2]) == [2]
    assert run([2, 4, 3, 5, 1]) == [1, 2, 3, 4, 5]
    assert run([2, 4, 6, 4, 2, 1, 3, 5, 3, 1]) == [1, 1, 2, 2, 3, 3, 4, 4, 5, 6]
  end
end
