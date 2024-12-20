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

Re-phrasing: from each track, I can "teleport" to any other track within 20
cartesian distance that is closer to the end.  The saving is the difference
minus the cartesian length of the cheat.

Special case: cheating to go to the next tile costs `n + 1 - n -1`, so `0`.

A cheat is only beneficial if its saving is greater than zero.  If I initialize
my list of "distances from the end" and put `Float::INFINITY` where there are
walls, I can simply select all grid positions with range and filter out those
that are greater than my current distance from the end.  This will remove all
these infinities.

I didn't need the histogram, after all.  Just counting the savings that were
above the threshold was enough.

## General Case

Puzzle 1 is the same as Puzzle 2, but with a maximum cheat length of 2.  I made
the code more generic in `puzzle_general.rb`.  The maximum length of cheats is
now a problem parameter and the same code solves either puzzle.
