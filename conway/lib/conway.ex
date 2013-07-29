defmodule Conway do
  import Data.Set.BalancedTree, as: SSet

  def main(_args) do
    run_pulsar
  end

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
    # at_exit doesn't work unless you 'mix escriptize'
    System.at_exit(fn(_code) -> show_cursor end)
    _run(SSet.new(generation))
  end

  defp _run(generation) do
    clear_screen
    print(generation)
    :timer.sleep 100
    _run(_evolve(generation))
  end

  defp clear_screen, do: IO.write "\e[2J"
  defp hide_cursor,  do: IO.write "\e[?25l"
  defp show_cursor,  do: IO.write "\e[?25h"

  defp print(cell_set, str // "*") do
    Enum.each(cell_set, fn(cell) -> print_cell(cell, str) end)
  end

  defp print_cell({x,y}, str), do: IO.write "\e[#{y + 25};#{2 * (x + 25)}H#{str}"

  def evolve(generation), do: _evolve(SSet.new(generation))
  def _evolve(generation) do
    #NOTE: a parallel Ruby version of the core evolve logic can be found
    # https://github.com/gvaughn/ruby_kata/blob/master/conway/conway.rb
    live_neighbor_stats = generation_stats(generation)
    Data.Set.union(Dict.get(live_neighbor_stats, 3, SSet.new),
      Data.Set.intersection(Dict.get(live_neighbor_stats, 2, SSet.new), generation)
    )
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
    Dict.update(collector, count, SSet.new([cell]), fn(s) -> Data.Set.add(s, cell) end)
  end

  defp neighbors({x, y}) do
    lc dx inlist [-1, 0, 1], dy inlist [-1, 0, 1], {dx,dy} != {0,0}, do: {x + dx, y + dy}
  end
end

