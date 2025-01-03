# [Day 18](https://adventofcode.com/2024/day/18)

## Puzzle 01

I used Dijkstra's algorithm to walk the memory space, then looked at the value
at the exit.

## Puzzle 02

Run Dijkstra's algorithm after each byte and check if we reached the exit.  We
know the first 1,024 bytes still leave a path, so we can start from there.  It
ran in **55,743ms**.

Someone suggested using a binary search instead of incrementally trying out
successive bytes.  I used Ruby's `#bsearch` and it ran in **91ms**.
