# [Day 14](https://adventofcode.com/2024/day/14)

## Puzzle 01

A `Robot` abstraction to represent each robot.  Modulo arithmetic to move them
across the space and wrap around edges.  I used Ruby's `Data` class to create
the `Robot` abstraction as an immutable object.  When a robot moves, it returns
a new `Robot` instance at the new location.  I've used `Struct` in the past, but
I wanted to experiment with an immutable structure, for a change.

## Puzzle 02

I printed the map after each move, driving it forward by pressing `enter`
repeatedly.  I looked for a pattern to slowly coalesce, but it was taking a long
time.

I thought there might be something with the periodicity of each robot's
movement.  But without a clue as to what to look for, there wasn't much I could
do there.

I tried to do binary search using the Advent of Code website.  Whenever I
submitted a guess, it would tell me "too low" or "too high".  With this, I found
out it was **between 5,000 and 10,000**.  When I tried 7,500, it told me I
essentially had "too many guesses", and stopped being helpful.

I looked at the
[subreddit](https://www.reddit.com/r/adventofcode/comments/1hdw23y/2024_day_14_part_2_what/)
for inspiration.  One recurring heuristic was to look for a bunch (10+) of
robots forming a horizontal line.

So, I looped through `5_000..10_000` seconds and for each computed the position
of each robot, looked for a row of 13+ robots with 13+ being side-by-side.  This
yielded **4 candidates**.  I printed them out and picked the one that showed a
Christmas tree.
