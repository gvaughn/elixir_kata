defmodule Conway do

  def run_glider do
    run([{-24,-22},{-23,-22},{-22,-22},{-22,-23},{-23,-24}])
  end

  def run_spaceship do
    run([{-24,0},{-23,0},{-22,0},{-21,0},{-21,-1},{-21,-2},{-22,-3},{-25,-1},{-25,-3}])
  end

  def run_pulsar do
    quadrant = [{2,1},{3,1},{4,1},{1,2},{1,3},{1,4},{2,6},{3,6},{4,6},{6,2},{6,3},{6,4}]
    start = lc {x,y} inlist quadrant, do: [{x,y},{-x,y},{x,-y},{-x,-y}]
    run(List.flatten(start))
  end

  def run(generation) do
    hide_cursor
    System.at_exit(fn(_code) -> show_cursor end)
    #TODO write a separate process to do IO.gets and sends a quit signal to this one
    # when any key is pressed and restore the cursor
    _run(generation)
  end

  defp _run(generation) do
    clear_screen
    print(generation)
    :timer.sleep 100
    _run(evolve(generation))
  end

  defp clear_screen, do: IO.write "\e[2J"
  defp hide_cursor,  do: IO.write "\e[?25l"
  defp show_cursor,  do: IO.write "\e[?25h"

  defp print([head|tail], str // "*") do
    print(head, str)
    print(tail, str)
  end

  defp print([], _), do: nil
  defp print({x,y}, str), do: IO.write "\e[#{y + 25};#{2 * (x + 25)}H#{str}"

  def evolve(generation) do
    #NOTE: a parallel Ruby version of the core evolve logic can be found
    # https://github.com/gvaughn/ruby_kata/blob/master/conway/conway.rb
    live_neighbor_stats = generation_stats(generation)
    Enum.sort(Dict.get(live_neighbor_stats, 3, []) ++
      intersection(Dict.get(live_neighbor_stats, 2, []), generation))
  end

  defp generation_stats(live_cells) do
    live_cells |> Enum.reduce(HashDict.new, function(cell_neighbor_counts/2))
               |> Enum.reduce(HashDict.new, function(neighbor_count_cells/2))
  end

  defp cell_neighbor_counts(live_cell, accumulator) do
    neighbors(live_cell) |> Enum.reduce(accumulator, fn(neighbor, acc) ->
      Dict.update(acc, neighbor, 1, &1 + 1)
    end)
  end

  defp neighbor_count_cells({cell, count}, collector) do
    Dict.update(collector, count, [cell], [cell | &1])
  end

  defp neighbors({x, y}) do
    (lc dx inlist [-1, 0, 1], dy inlist [-1, 0, 1], do: {x + dx, y + dy}) -- [{x, y}]
  end

  defp intersection(a, b) do
    :sets.from_list(a) |> :sets.intersection(:sets.from_list(b)) |> :sets.to_list
  end
end

