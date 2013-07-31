defmodule RomanNumerals do

  @moduledoc """
  Task definition: Create a function taking a positive integer as its parameter and
  returning a string containing the Roman Numeral representation of that integer.
  """

  @mappings [{"X", 10}, {"IX", 9}, {"V", 5}, {"IV", 4}, {"I", 1}]

  def convert(number) do
    {0, str} = @mappings |> Enum.reduce {number, ""}, fn
      ({roman, arabic}, {number, str}) when number >= arabic ->
        {rem(number, arabic), str <> String.duplicate(roman, div(number, arabic)) }
      (_, accum) -> accum
    end
    str
  end
end

ExUnit.start

defmodule RomanNumeralsTest do
  use ExUnit.Case

  test "converts arabic numbers to roman" do
    Enum.each [ [1,"I"],
                [2,"II"],
                [3,"III"],
                [4,"IV"],
                [5,"V"],
                [6,"VI"],
                [7,"VII"],
                [8,"VIII"],
                [9,"IX"],
                [10,"X"],
                [11,"XI"],
                [14,"XIV"],
                [19,"XIX"],
                [20,"XX"],
                [25,"XXV"],
                [27,"XXVII"] ], fn [arabic, roman] ->
          assert roman == RomanNumerals.convert(arabic)
    end
  end
end
