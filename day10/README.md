# [Day 10](https://adventofcode.com/2024/day/10)

## Puzzle 01

I used recursion to hike from trailheads and collect the coordinates of `9`s
that I could reach.  I used `#uniq` to get a score as "how many `9`s I can reach
from this trailhead."

## Puzzle 02

By removing the call to `#uniq`, the `#hike` method returned one coordinate for
each path.  Counting the paths gave me the rating I was looking for.
