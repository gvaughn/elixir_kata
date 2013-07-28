# Conway

My first Elixir program: Conway's Game of Life

# Now with Visualization

I figured out the ANSI escape sequences to draw this on the console.
Plus, I provided a few interesting starting blobs. First compile:

```
elixirc "lib/conway.ex"
```
Then run can run any of the following:

* elixir -e "Conway.run_glider"
* elixir -e "Conway.run_spaceship"
* elixir -e "Conway.run_pulsar"

You could also set your own pairs of x, y coordinates via:

* elixir -e "Conway.run [{1,2}, {1,1}, {1,0}]"

In Conway.evolve, it takes a list of 2 element tuples representing x, y
coordinates of live cells. It uses the center of the screen as the
origin (0,0). It returns a list of 2 element tuples
represeting the new generation, suitable to feed back into the function.

##Make It Stop!
control-C. Twice. It's an Erlang thing apparently.

##Wha' Happened to My CURSOR?
Yeah. That. Sorry, but I haven't figured it out yet. I tried a System.at_exit call to restore it, but no joy. This should get that cursor back:

```
echo -e "\033[?25h"
```

or else open a new terminal window

## Sample inputs
### Static block
[{0,1}, {1,1}, {0,0}, {1,0}] returns itself
### Blinker (2-cycle shape)
[{1,2}, {1,1}, {1,0}] returns [{0,1},{1,1},{2,1}] which itself returns
the original
### Toad (another 2-cycle shape)
[{1,1}, {2,1}, {3,1}, {0,0}, {1,0}, {2,0}] returns [{2,2}, {0,1}, {3,1},
{0,0}, {3,0}, {1,-1}] which itself returns the original
