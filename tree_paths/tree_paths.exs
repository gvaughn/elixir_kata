defmodule Tree do

  def from_paths(list_of_paths) do
    # first turn into cons trees [1,2,3] -> [1, [2, [3]]]
    # then merge
    # then wrap in map stuff
    list_of_paths
    |> Enum.map(&to_cons_tree/1)
    |> Enum.reduce(&merge_cons_trees({&1, &2}))
    # |> wrap_in_map # TBD
  end

  defp to_cons_tree(flat_path) do
    {branches, leaf} = Enum.split(flat_path, -1)
    List.foldr(branches, leaf, &[&1 | [&2]])
  end

  defp merge_cons_trees({a, a}), do: a

  defp merge_cons_trees({left, right}) when length(left) > 1 and length(right) > 1 do
    Enum.zip(left, right) |> Enum.map(&merge_cons_trees/1)
  end

  defp merge_cons_trees({a, b}), do: a ++ b

end

a = [1, 2, 3]
b = [1, 2, 4]

Tree.from_paths([a, b])
|> IO.inspect
