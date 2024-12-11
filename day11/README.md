# [Day 11](https://adventofcode.com/2024/day/11)

## Puzzle 01

I created a `Stone` class that implemented the algorithm in its `#blink` method.
It stores the number and caches it as a string internally.  This way, it can
check the number of digits and split them when needed.

The sample data took **136ms** and the real input took **416ms** to process only
25 blinks.  This feels long.

## Puzzle 02

The approach from Puzzle 1 stopped responding around blink 35.  I needed a new
approach.

Divide and Conquer.  Blink once and add up the counts from blinking **n-1**
times each resulting stone.  Caching helps, as certain numbers tends to come
back again and again.

With this new approach, the sample data took **63ms** and the real input only
took **381ms**.  That's for 75 blinks!!
