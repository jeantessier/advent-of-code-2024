# [Day 24](https://adventofcode.com/2024/day/24)

## Puzzle 1

I used a small class hierarchy to represent the gates, and looped until all the
gates were determined.

Ruby has helpers to convert octal and hex strings to numbers, but not for
binary.  I used bitwise operations to get the number from the `z??` wires.

## Puzzle 2

X and Y are 45 bits wide, and Z is 46 bits wide.  There are 222 gates.  A brute
force search be in **O(n<sup>8</sup>)** possible swaps.  For `n = 222`, that's
almost 6 quintillions.

If I walk back from the `z??` wires, I can find all the gates that lead to Z.
At least one of them must be swapped, otherwise Z wouldn't change.  However,
when I walk back from Z, I reach each of the 222 gates.
