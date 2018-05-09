defmodule Input do
  defstruct billAmount: 0.0, tipRate: 0.0
end

defmodule Output do
  defstruct tip: 0.0, total: 0.0
end

defmodule TaxCalculator do
  def main(_argv) do
    readBillAmount()
    |> calculateTaxAmount
    |> printResult
  end

  def readFloatInput(message) do
    IO.gets("#{message}\n")
    |> Float.parse
    |> handleFloatParsing(&TaxCalculator.readFloatInput/1, message) 
  end

  def handleFloatParsing(result, func, message) do
    case result do
      :error ->
        func.(message)
      {float, _} -> float
    end
  end

  def readBillAmount do
    billAmount = readFloatInput("What is the bill amount?")
    tipRate = readFloatInput("What is the tip rate?")
    %Input{billAmount: billAmount, tipRate: tipRate}
  end

  def calculateTaxAmount(input) do
    tip = input.billAmount * (input.tipRate/100)
    total = input.billAmount + tip
    %Output{total: total, tip: tip}
  end

  def printResult(output) do
    IO.puts "Tip: $#{output.tip}"
    IO.puts "Total: $#{output.total}"
  end
end

TaxCalculator.main([])
