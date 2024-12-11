# [Day 11](https://adventofcode.com/2024/day/11)

## Puzzle 01

I created a `Stone` class that implemented the algorithm in its `#blink` method.
It stores the number and caches it as a string internally.  This way, it can
check the number of digits and split them when needed.

The sample data took **136ms** and the real input took **416ms** to process only
25 blinks.  This feels long.

## Puzzle 02

The approach from Puzzle 1 stops responding around blink 35.  I need a new
approach.
