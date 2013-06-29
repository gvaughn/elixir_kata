# Conway

My first Elixir program: Conway's Game of Life

In Conway.evolve, it takes a list of 2 element tuples representing x, y
coordinates of live cells. It returns a list of 2 element tuples
represeting the new generation, suitable to feed back into the function.

## To Run (the only way I've learned thus far)
1. Install Elixir
2. enter iex
3.   c "lib/conway.ex"
4. Conway.evolve ...

## Sample inputs
### Static block
[{0,1}, {1,1}, {0,0}, {1,0}] returns itself
### Blinker (2-cycle shape)
[{1,2}, {1,1}, {1,0}] returns [{0,1},{1,1},{2,1}] which itself returns
the original
### Toad (another 2-cycle shape)
[{1,1}, {2,1}, {3,1}, {0,0}, {1,0}, {2,0}] returns [{2,2}, {0,1}, {3,1},
{0,0}, {3,0}, {1,-1}] which itself returns the original
