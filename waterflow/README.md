# Waterflow

Inspired by http://qandwhat.apps.runkite.com/i-failed-a-twitter-interview/
a Twitter interview question. Given the height of mountains in some terrain,
imagine a heavy rain that fills the low lying areas as much as possible.
Calculate the total area (since it's a 2 dimensional problem) of water.

The link above is to an elegant Haskell solution that was a
straightforward port to Elixir. It was my first encounter with
Enum.scan, which is similar to reduce, but keeps the accumulator at each
step as elements of the returned list. Haskell apparently has built-ins
for scanr (scan from the right) and zip_with that I wrote as helpers.
I'm fond of zip_with because it allows me to avoid the boilerplate code
of destructuring the 2-tuple from zip, and I find I often want to map
the results of the zip.

# Execute
elixir waterflow.exs
