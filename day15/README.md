# [Day 15](https://adventofcode.com/2024/day/15)

## Puzzle 01

Simply ran a simulation.  Created `Coord` and `Move` abstractions to handle
coordinates and positions.  Used recursion to move the robot.  If it moved into
an obstacle or free space, that was easy to handle.  If it moved into a box,
then it recursively attempted to move the box first and the robot only if the
space became empty.

Printing the map after each move made the runtime **over 2s**.  Removing the
trace statements took the runtime down to **135ms**.

## Puzzle 02

