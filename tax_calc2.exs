defmodule TaxCalc2 do
  def main(_argv) do
    %{}
    |> read_float_input("What is the bill amount?", :bill_amount)
    |> read_float_input("What is the tip rate?", :tip_rate)
    |> calculate_tax_amount
    |> print_result
  end

  def read_float_input(result, message, key) do
    raw_input = IO.gets("#{message}\n")
    case Float.parse(raw_input) do
      {float, _} -> Map.put(result, key, float)
      :error     -> read_float_input(result, message, key)
    end
  end

  defp calculate_tax_amount(%{bill_amount: bill_amount, tip_rate: tip_rate}) do
    tip = bill_amount * (tip_rate/100)
    total = bill_amount + tip
    %{total: total, tip: tip}
  end

  defp print_result(output) do
    IO.puts "Tip: $#{output.tip}"
    IO.puts "Total: $#{output.total}"
  end
end

# TaxCalc2.main([])

ExUnit.start

defmodule TaxCalc2Test do
  use ExUnit.Case
  import ExUnit.CaptureIO

  test "handles error float parsing" do
    user_input = ["iamnotafloat", "still no float", "😎", "1.1"]

    prompts = capture_io(Enum.join(user_input, "\n"), fn ->
      send(self(), TaxCalc2.read_float_input(%{}, "prompt", :float_key))
    end)

    assert_received %{float_key: 1.1}

    prompt_list = String.split(prompts)
    assert length(prompt_list) == length(user_input)
    assert ["prompt"] == Enum.uniq(prompt_list)
  end
end
