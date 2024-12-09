# [Day 09](https://adventofcode.com/2024/day/9)

## Puzzle 01

The input is 20,000 single digit numbers.  I would need at most 200KB to create
a block map.  It's worth a try and runs fast enough.  I could have tracked each
group of consecutive blocks instead, but I didn't feel the added complexity was
worth it, yet.

## Puzzle 02

First solution took **5m14s**.  It moved backwards from the last file and looked
for a free space large enough to accommodate it.  **O(n<sup>2</sup>)** style.

On top of that, a file might get visited more than once.  This creates extra
work, but does not change the result.  If the file didn't fit anywhere left of
here before, it still won't fit anywhere left of here now.

One quick optimization is to stop looking when the file starts before the first
free block, and to stop looking for free space past the file's start.
