defmodule Luhn do

  def valid?(cc) when is_integer(cc) do
    {_, sum} = Integer.digits(cc)
        |> Enum.reverse
        |> Enum.chunk(2, 2, [0])
        |> Enum.map_reduce(0, fn([a,b], sum) -> {[], sum + a + Enum.sum(Integer.digits(b*2))} end)
    rem(sum, 10) == 0
  end

  def valid?(cc) when is_binary(cc) do
    case String.replace(cc, " ", "") |> Integer.parse do
      {cc_int, _} -> valid?(cc_int)
      _ -> {:error, "Cannot parse integer from string"}
    end
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

  test "what happens with invalid integer input?" do
    assert {:error, _} = Luhn.valid?("abc123")
  end

  test "spaces are ok" do
    assert Luhn.valid?("7992 7398 713")
  end

end

