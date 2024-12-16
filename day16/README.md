# [Day 16](https://adventofcode.com/2024/day/16)

## Puzzle 01

Another path-finding exercise.  I build a list of `Path` objects, starting with
a path starting at `S` and facing East.  Each iteration, I pick out "active"
paths and look right, foward, and left from the path's head.  If the path meets
a dead-end or wraps in on itself, it becomes inactive.  If there are multiple
options, the path clones itself to explore right or left paths.

The first sample took **77** cycles to explore **285** paths.  The second sample
took **98** cycles to explore **122** paths.  I stopped the run against the
input after **101** cycles, when it was exploring **3,288,597** paths (2M of
which were still active).  I was running out of memory and each new cycle was
taking a really long time.

I need a new approach.

## Puzzle 02


