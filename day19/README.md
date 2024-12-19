# [Day 19](https://adventofcode.com/2024/day/19)

## Puzzle 01

A simple recursive function to check if a pattern or sub-pattern is achievable,
combined with Ruby's `#any?` method.

## Puzzle 02

Changed the recursive function to return a count of possible combinations
instead of just `true`/`false`.  It took forever to run, but I suspected that
sub-patterns came up again and again.  I cached partial results so as not to
recompute them and the whole thing ran in **267ms**.
