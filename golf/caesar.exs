Code.require_file("golf.exs", __DIR__)

# See http://elixirgolf.com/articles/the-elixir-caesar-cipher/
defmodule Caesar do
  use Golf

  # If we didn't have to handle spaces in the input
  # {_,[n,p]}=:io.fread"",'~d,~s';IO.puts for c<-p,do: 97+rem c-71-n,26
  def doit() do
    # comments are ignored
    [n,p]=String.split IO.gets(""),",";IO.puts for<<c<-p>>,do: c<?a&&c||?a+rem c-71-String.to_integer(n),26
  end
end
