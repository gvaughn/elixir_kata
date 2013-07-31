defmodule Conway do
  @moduledoc """
    Conway's Game of Life
    This implementation works without a fixed grid size. It operates on a set of
    life cells, which themselves are an {x, y} tuple
  """

  @doc """
    convenience method for a glider than moves down and to the right
  """
  def run_glider do
    run([{-24,-22},{-23,-22},{-22,-22},{-22,-23},{-23,-24}])
  end

  @doc """
    convenience method for a spaceship that moves right
  """
  def run_spaceship do
    run([{-24,0},{-23,0},{-22,0},{-21,0},{-21,-1},{-21,-2},{-22,-3},{-25,-1},{-25,-3}])
  end

  @doc """
    convenience method for a static periodic shape
  """
  def run_pulsar do
    quadrant = [{2,1},{3,1},{4,1},{1,2},{1,3},{1,4},{2,6},{3,6},{4,6},{6,2},{6,3},{6,4}]
    start = lc {x,y} inlist quadrant, do: [{x,y},{-x,y},{x,-y},{-x,-y}]
    run(List.flatten(start))
  end

  @doc """
    core visualization entry method
    takes a list of 2 element tuples
  """
  def run(generation) do
    hide_cursor
    System.at_exit(fn(_code) -> show_cursor end)
    #TODO write a separate process to do IO.gets and sends a quit signal to this one
    # when any key is pressed and restore the cursor
    _run(generation)
  end

  @doc """
    core visualization recursion point
    takes a list of 2 element tuples
    returns the same
  """
  defp _run(generation) do
    clear_screen
    print(generation)
    :timer.sleep 100
    _run(evolve(generation))
  end

  @doc """
    ANSI control sequences
  """
  defp clear_screen, do: IO.write "\e[2J"
  defp hide_cursor,  do: IO.write "\e[?25l"
  defp show_cursor,  do: IO.write "\e[?25h"

  defp print(generation, str // "*"), do: Enum.each(generation, print_cell(&1, str))
  defp print_cell({x,y}, str), do: IO.write "\e[#{y + 25};#{2 * (x + 25)}H#{str}"

  @doc """
    core engine recursion point
    takes a list of 2 element tuples
    returns the same

    Core algorithm: the next generation consists of:
      cells with 3 live neighbors plus
      cells with 2 live neighbors that were also alive in the last generation
  """
  def evolve(generation) when is_list(generation), do: evolve(HashSet.new(generation))
  def evolve(generation) do
    #NOTE: a parallel Ruby version of the core evolve logic can be found
    # https://github.com/gvaughn/ruby_kata/blob/master/conway/conway.rb
    live_neighbor_stats = generation_stats(generation)
    Set.union(Dict.get(live_neighbor_stats, 3, HashSet.new),
      Set.intersection(Dict.get(live_neighbor_stats, 2, HashSet.new), generation))
  end

  @doc """
    generates a Dict of live neightbor counts as keys and
    a set of cells having that many neighbors as the value
  """
  defp generation_stats(live_cells) do
    live_cells |> Enum.reduce(HashDict.new, function(cell_neighbor_counts/2))
               |> Enum.reduce(HashDict.new, function(neighbor_count_cells/2))
  end

  @doc """
    generates a Dict of cells {x,y} as keys and
    the number of live neighbors they have as values
  """
  defp cell_neighbor_counts(live_cell, accumulator) do
    neighbors(live_cell) |> Enum.reduce(accumulator, fn(neighbor, acc) ->
      Dict.update(acc, neighbor, 1, &1 + 1)
    end)
  end

  @doc """
    inverts a Dict<cell -> count> to
    Dict<count -> set of cells>
  """
  defp neighbor_count_cells({cell, count}, collector) do
    Dict.update(collector, count, HashSet.new([cell]), fn(set) -> Set.put(set, cell) end)
  end

  @doc """
    finds surrounding cells of a given cell, excluding the original cell
  """
  defp neighbors({x, y}) do
    lc dx inlist [-1, 0, 1], dy inlist [-1, 0, 1], {dx,dy} != {0,0}, do: {x + dx, y + dy}
  end
end

