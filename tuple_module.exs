defmodule Car do
  def new(type), do: {Car, type}
  def accelerate(speed, {Car, type}) do
    case type do
      :sports -> "ZOOOMMM! to #{speed}"
      :sedan  -> "buuuummmm ... bummmmmm ... bummmmm ... (are we at #{speed} yet?)"
      :jalopy -> "putter-putter"
    end
  end
end

car = Car.new(:sports)
IO.puts car.accelerate(60)
