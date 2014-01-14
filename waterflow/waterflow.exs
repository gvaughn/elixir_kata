defmodule Waterflow do

  def area(terrain) do
    # find the tallest height on the left at each index
    left_max = Enum.scan(terrain, &max/2)
    # find the tallest height on the right at each index
    right_max = scanr(terrain, &max/2)
    # water level at each index is the min of the max height to either side
    water = zip_with(left_max, right_max, &min/2)
    # but we must subtract out the terrain
    depths = zip_with(water, terrain, &(&1 - &2))
    # total area of water is just sum
    Enum.reduce(depths, 0, &(&1 + &2))
  end

  def area2(terrain) do
    # same as area without intermediate variables
    zip_with(Enum.scan(terrain, &max/2), scanr(terrain, &max/2), &min/2)
    |> zip_with(terrain, &(&1 - &2))
    |> Enum.reduce(0, &(&1 + &2))
  end

  defp scanr(list, f) do
    list |> Enum.reverse |> Enum.scan(f) |> Enum.reverse
  end

  defp zip_with(list1, list2, f) do
    Stream.zip(list1, list2) |> Enum.map(fn {a, b} -> f.(a,b) end)
  end
end

ExUnit.start

defmodule WaterflowTest do
  use ExUnit.Case

  test "simple" do
    #  _   _
    # |_|~|_|
    #  0 1 2
    assert 1 == Waterflow.area [1, 0, 1]
    assert 1 == Waterflow.area2 [1, 0, 1]
  end

  test "none collected" do
    #        _
    #      _| |
    #    _|   |
    #   |     |
    #  --------
    #  0 1 2 3
    assert 0 == Waterflow.area [0,1,2,3]
    assert 0 == Waterflow.area2 [0,1,2,3]
  end

  test "complex case" do
    #              ___
    #             |7 7|_
    #    _        |    6|
    #   |5|~~~~~~~|     |
    #   | |~~~~~|4      |
    #  _| |~~~|3        |
    # |2  |~|2          |
    # |    1            |
    #  -----------------
    #  0 1 2 3 4 5 6 7 8
    assert 10 == Waterflow.area [2,5,1,2,3,4,7,7,6]
    assert 10 == Waterflow.area2 [2,5,1,2,3,4,7,7,6]
  end
end

