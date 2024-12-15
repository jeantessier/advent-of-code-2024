# [Day 15](https://adventofcode.com/2024/day/15)

## Puzzle 01

Simply ran a simulation.  Created `Coord` and `Move` abstractions to handle
coordinates and positions.  Used recursion to move the robot.  If it moved into
an obstacle or free space, that was easy to handle.  If it moved into a box,
then it recursively attempted to move the box first and the robot only if the
space became empty.

Printing the map after each move made the runtime **over 2,000ms**.  Removing the
trace statements took the runtime down to **135ms**.

## Puzzle 02

The `#one_movement` method now takes a list of positions and attempts to move
them together.  It starts each movement attempt with a single position, that of
the robot.  If any position would move to an obstacle, we abort.  If all new
positions are open, then we swap _en block_.

Pushing boxes horizontally is the same as before.

Pushing boxes vertically is more complicated.  I thought I could simply grow a
space above or below the current position and move that recursively.  But there
is a strange corner case:

```
..............
....[][][]....
....[]..[]....
.....[][].....
......[]......
.......@......

Move: ^
....[]..[]....
....[][][]....
.....[][].....
......[]......
.......@......
..............
```

The box in the middle, with empty space below it, doesn't get pushed by the
robot pushing on the other boxes.  Analyzing all the configurations of boxes and
spaces and their resulting effect would get complicated pretty quickly.  I would
be better off having a separate method that _attempts_ to move each box before
it them actually moves them if possible.

Here, I've numbered the boxes so we can see what would happen.

```
..............
....668877....
....44..55....
.....2233.....
......11......
.......@......
```

```
Robot wants to go up.
  Can box 11 go up?
    Can boxes 22 and 33 go up?
      Can box 22 go up?
        Can box 44 go up?
          Can box 66 go up?
          Yes
        Yes
      Yes
      Can box 33 go up?
        Can box 55 go up?
          Can box 77 go up?
          Yes
        Yes
      Yes
    Yes
  Yes
  Move box 11 up
    Move boxes 22 and 33 up
      Move box 22 up
        Move box 44 up
          Move box 66 to empty space
          Move box 44 to empty space
        Move box 22 to empty space
      Move box 33 up
        Move box 55 up
          Move box 77 to empty space
          Move box 55 to empty space
        Move box 33 to empty space
    Move box 11 to empty space
  Move robot to empty space
```

If boxes `66` or `77` are blocked, it prevents anything from moving.  If box
`88` is blocked, it does not affect anything.

By printing the map on each iteration, the runtime was **3,440ms**.  Without all
the traces, it came down to **160ms**.
