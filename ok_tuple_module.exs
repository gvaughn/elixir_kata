defmodule :ok do
  def result({:ok, result}), do: result
end

IO.puts {:ok, 42}.result
