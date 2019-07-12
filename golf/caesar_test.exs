Code.require_file("caesar.exs", __DIR__)
ExUnit.start()
defmodule CaesarGolf do
  use ExUnit.Case
  import ExUnit.CaptureIO

  test "caesar example" do
    input = "3,abc defg hijklmnopqrstuvwxyz"
    expected = "xyz abcd efghijklmnopqrstuvw\n"

    output = capture_io([input: input, capture_prompt: false], fn ->
      retval = Caesar.doit()
      send self(), {:retval, retval}
    end)

    retval = receive do
      {:retval, retval} -> retval
    end

    # NOTE output captures the trailing newline from IO.puts
    assert output == expected || retval == expected
  end
end
