# Day 06

## Puzzle 01

I used an array of arrays to represent the map with obstacles and everything.
I simply ran forward the guard until it would exit the map's boundaries.

## Puzzle 02

I went for a brute force approach.  I figured I could try an obstacle at every
open position and see if the guard exits the map.  At first, I thought the loop
had to go through the starting position again.  But there are other loops that
don't revisit the starting position, so I had to track, for each position, which
direction the guard was traveling through.  If the guard visited the same
position from the same direction twice, that would indicate there was a loop.
If the guard exited the map, then there was no loop.

An obvious optimization would be to try only positions that the guard actually
visits in the original layout.
