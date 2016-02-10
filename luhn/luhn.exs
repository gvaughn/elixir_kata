defmodule Luhn do

  def valid?(cc) do
    {_, sum} = String.to_integer(cc)
        |> Integer.digits
        |> Enum.reverse
        |> Enum.chunk(2, 2, [0])
        |> Enum.map_reduce(0, fn([a,b], sum) -> {[], sum + a + Enum.sum(Integer.digits(b*2))} end)
    rem(sum, 10) == 0
  end
end

ExUnit.start

defmodule LuhnTest do
  use ExUnit.Case

  test "checks known valid number from wikipedia" do
    assert Luhn.valid?("79927398713")
  end

  test "checks transposed digits of known valid number from wikipedia" do
    refute Luhn.valid?("97927398713")
  end

end

