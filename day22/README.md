# [Day 22](https://adventofcode.com/2024/day/22)

## Puzzle 1

Some simple bitwise arithmetic in a loop.  Multiplying and dividing by powers of
2 is really just shifting bits around.  I used Ruby's `#reduce` to repeat the
operation a number of times, carrying the result forward.

## Puzzle 2

For each buyer, I populated a table of each sequence of 4 changes and the price
at that time.  If a sequence occurred multiple times, I only recorded the price
at its first occurrence.  I then collected all possible sequences across all
buyers, and for each sequence, collected the prices across buyers (with zero if
the sequence didn't occur for that buyer).  `#sum` and `#max` gave me my answer.
It did take over **21 seconds** to run, though.
