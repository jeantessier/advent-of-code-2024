# [Day 14](https://adventofcode.com/2024/day/14)

## Puzzle 01

A `Robot` abstraction to represent each robot.  Modulo arithmetic to move them
across the space and wrap around edges.  I used Ruby's `Data` class to create
the `Robot` abstraction as an immutable object.  When a robot moves, it returns
a new `Robot` instance at the new location.  I've used `Struct` in the past, but
I wanted to experiment with an immutable structure, for a change.

## Puzzle 02


