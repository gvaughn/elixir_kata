defmodule ConwayTest do
  use ExUnit.Case, async: true

  test "handles static block object" do
    block = [{0,1}, {1,1},
             {0,0}, {1,0}
    ]
    assert Conway.evolve(block) |> Enum.to_list |> Enum.sort == Enum.sort(block)
  end

  test "handles a blinker" do
    blinker_a = [       {1,2},
                        {1,1},
                        {1,0}
    ]
    blinker_b = [{0,1}, {1,1}, {2,1}
    ]
    assert Conway.evolve(blinker_a) |> Enum.to_list |> Enum.sort == Enum.sort(blinker_b)
    assert Conway.evolve(blinker_b) |> Enum.to_list |> Enum.sort == Enum.sort(blinker_a)
  end

  test "handles a toad" do
    toad_a = [       {1,1}, {2,1}, {3,1},
              {0,0}, {1,0}, {2,0}
    ]
    toad_b = [              {2,2},
             {0,1},                {3,1},
             {0,0},                {3,0},
                    {1,-1}
    ]
    assert Conway.evolve(toad_a) |> Enum.to_list |> Enum.sort == Enum.sort(toad_b)
    assert Conway.evolve(toad_b) |> Enum.to_list |> Enum.sort == Enum.sort(toad_a)
  end
end
