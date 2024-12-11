# [Day 10](https://adventofcode.com/2024/day/10)

## Puzzle 01

I used recursion to hike from trailheads and collect the coordinates of `9`s
that I could reach.  I used `#uniq` to get a score as "how many `9`s I can reach
from this trailhead."

## Puzzle 02

By removing the call to `#uniq`, the `#hike` method returned one coordinate for
each path.  Counting the paths gave me the rating I was looking for.

## JavaScript

I tried to port this solution to JavaScript.  For fun.  The hard part was
replicating Ruby's `Array#uniq`.  I used simple tuples for coordinates, and a
JavaScript `Set` didn't de-dupe them because it used object identity to find
duplicates.  In the end, I converted coordinates to JSON strings before
de-duping, and that did the trick.
