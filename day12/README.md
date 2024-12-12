# [Day 12](https://adventofcode.com/2024/day/12)

## Puzzle 01

I created `Plot` and `Region` abstractions to handle some of the calculations
and boundary checking.  I struggled a bit with merging plots into a region.  My
solution takes over **4s** to run against the input, in part because it goes
over lists of plots over and over again as it tries to connect them into
regions.

## Puzzle 02


