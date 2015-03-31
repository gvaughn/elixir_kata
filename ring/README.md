# Play a Game

This is something found via a LivingSocial brownbag lunch that are for
high school programming competitions at Virginia Commonwealth
University.

Modulo a diagram of 6 numbered circle in a circle, this is how the
description was given:

## Ring

N people are playing a game. They sit in a circle with N seats.

Starting from the person sitting on seat "1", they count off clockwise
by three. The person who has "threee" loses and leaves the circle. Then,
the rest continue playing the game by starting from the person who is
the clockwise next to the leaving one until there is only one left. The
one left is the winner. In an example of 6 players, the first person to
be eliminated is person seating at seat "3", then "6", then "4", then
"2", then "5", until only person seating at seat "1" is left.

Input
Single integer 1 < N <= 100000 that indicates the number of game
participants

Output
Single integer: the winner's seat number

Sample Input
6

Sample Output
1
