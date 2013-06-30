defmodule Conway do

  def evolve(generation) do
    live_neighbor_stats = generation_stats(generation)
    Enum.sort(Dict.get(live_neighbor_stats, 3, []) ++
      intersection(Dict.get(live_neighbor_stats, 2, []), generation))
  end

  defp intersection(a, b) do
    :sets.to_list(:sets.intersection(:sets.from_list(a), :sets.from_list(b)))
  end

  defp generation_stats(live_cells) do
    live_cells |> Enum.reduce(HashDict.new, function(cell_neighbor_counts/2))
               |> Enum.reduce(HashDict.new, function(neighbor_count_cells/2))
  end

  defp cell_neighbor_counts(live_cell, accumulator) do
    neighbors(live_cell) |> Enum.reduce accumulator, fn(neighbor, acc) ->
      Dict.update(acc, neighbor, 1, &1 + 1)
    end
  end

  defp neighbor_count_cells({cell, count}, collector) do
    Dict.update(collector, count, [cell], &1 ++ [cell])
  end

  defp neighbors({x, y}) do
    [{x - 1 ,y + 1}, {x, y + 1}, {x + 1, y + 1},
     {x - 1, y},                 {x + 1, y},
     {x - 1, y - 1}, {x, y - 1}, {x + 1, y - 1}]
  end
end

