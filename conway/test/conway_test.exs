Code.require_file "test_helper.exs", __DIR__

defmodule ConwayTest do
  use ExUnit.Case

  test "handles static block object" do
    block = [{0,1}, {1,1},
             {0,0}, {1,0}
    ]
    assert Enum.to_list(Conway.evolve(block)) == Enum.sort(block)
  end

  test "handles a blinker" do
    blinker_a = [       {1,2},
                        {1,1},
                        {1,0}
    ]
    blinker_b = [{0,1}, {1,1}, {2,1}
    ]
    assert Enum.to_list(Conway.evolve(blinker_a)) == Enum.sort(blinker_b)
    assert Enum.to_list(Conway.evolve(blinker_b)) == Enum.sort(blinker_a)
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
    assert Enum.to_list(Conway.evolve(toad_a)) == Enum.sort(toad_b)
    assert Enum.to_list(Conway.evolve(toad_b)) == Enum.sort(toad_a)
  end
end
