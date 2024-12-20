# [Day 20](https://adventofcode.com/2024/day/20)

## Puzzle 01

Each racetrack has a single path from `S` to `E`.  I walked it backwards from
`E`, counting up with each step.  This way, at each track, I know how far I am
from the end.

I figured each working cheat removed a single piece of an interior wall from the
racetrack.  So for each piece of interior wall, I found the connected tracks on
each side and looked at their distances from the end.  That gave me saving for
that single cheat as the difference in distances (minus 2 for taking the
shortcut).

Put all the savings in a histogram, filter by the threshold of `100`, and sum
the counts that passed the filter.  Ran in **121ms**

## Puzzle 02


