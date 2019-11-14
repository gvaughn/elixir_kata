#! /usr/bin/env elixir
# execute with `./caesar_test.exs`

Code.require_file("caesar.exs", __DIR__)
ExUnit.start()

defmodule CaesarGolf do
  use ExUnit.Case
  import ExUnit.CaptureIO

  describe "caesar example" do
    # for each public function in Caesar module
    for f <- :functions |> Caesar.__info__() |> Keyword.keys() do

      test f do
        input = "3,abc defg hijklmnopqrstuvwxyz"
        expected = "xyz abcd efghijklmnopqrstuvw"

        assert expected == output_of(Caesar, unquote(f), input)
      end
    end
  end

  def output_of(mod, fun, input) do
    capture_io([input: input, capture_prompt: false], fn ->
      retval = apply(mod, fun, [])
      # allow test access to the return value when necessary
      #   retval = receive do
      #     {:retval, retval} -> retval
      #   end
      send self(), {:retval, retval}
    end)
    |> String.trim_trailing()
    # NOTE output captures the trailing newline from IO.puts so we trim it
  end
end
