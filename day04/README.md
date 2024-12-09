# [Day 04](https://adventofcode.com/2024/day/4)

## Puzzle 1

At first, I figured I could look at each character, and based on which letter it
was, look for `XMAS` in all 8 compass points: E, NE, N, NW, W, SW, S, and SE.  I
would count each occurrence 4 times, but I could divide the total by 4 to get me
an answer.  Then, I realized I only needed to locate `X` and search from there.
This way, there was no over counting.

The reading methods each only returns 4 characters.  If it is too close to the
edge to get 4 characters, they return an empty string.

## Puzzle 2

Similar approach: look for `A` and check diagonals.  Since the `A` cannot be on
the edge, this simplifies things quite a bit.  Check for `A` inside the edge,
and the diagonals _de facto_ exist.  All that's left is checking they both spell
out `MAS` forward or backward.
