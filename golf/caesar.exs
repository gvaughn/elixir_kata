Code.require_file("golf.exs", __DIR__)

# See http://elixirgolf.com/articles/the-elixir-caesar-cipher/
defmodule Caesar do
  use Golf

  def doit() do
    # comments are ignored
    [n,p]=String.split IO.gets"",",";IO.puts for<<c<-p>>,do: c<?a&&c||?a+rem c-71-String.to_integer(n),26
  end

  def henrik() do
    [n,p]=IO.gets("")|>String.split",";IO.puts for<<c<-p>>,do: c<97&&c||97+rem c-71-String.to_integer(n),26
  end

  def peter_marrek() do
    {n,","<>p}=IO.gets("")|>Integer.parse;IO.puts for<<c<-p>>,do: c<?a&&c||?a+rem c-71-n,26
  end

  def tweaked_peter_marrek() do
    {n,","<>p}=Integer.parse IO.gets"";IO.puts for<<c<-p>>,do: c<?a&&c||?a+rem c-71-n,26
  end

  # If we didn't have to handle spaces in the input
  def no_input_spaces() do
    {_,[n,p]}=:io.fread"",'~d,~s';IO.puts for c<-p,do: 97+rem c-71-n,26
  end

end
