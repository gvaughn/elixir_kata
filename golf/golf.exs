defmodule Golf do
  # This was done for fun. It's a fancy way to count the number of characters
  # in each function at compile time and print the result.
  defmacro __using__(_opts) do
    quote do
      @on_definition unquote(__MODULE__)
    end
  end

  def __on_definition__(env, _kind, name, _qargs, _qguards, _qbody) do
    [def_line | rest_lines] =
      env.file
      |> File.stream!()
      |> Stream.drop(env.line - 1)
      |> Enum.to_list()

    [leading_spaces, _] = Regex.split(~r/\b/, def_line, parts: 2)

    body_lines =
      Enum.take_while(rest_lines, &not(String.starts_with?(&1, "#{leading_spaces}end")))
      |> Enum.reject(&(&1 =~ ~r/^\s+#/))

    body =
      body_lines
      |> Enum.map(&String.trim_leading(&1, " "))
      |> Enum.join()
      |> String.trim_trailing()

    IO.puts("#{name} length: #{String.length(body)} chars")
  end
end
