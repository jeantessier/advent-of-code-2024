# [Day 23](https://adventofcode.com/2024/day/23)

## Puzzle 1

I parsed the input into a map of computer-to-connections.  I only focused on
computers starting with `t`, since that's all we cared about.  For each
computer, I used Ruby's `#intersection` to find common computers between a given
computer and each of its direct connections.  A computer is not connected to
itself, so it does not appear in its own list of connections.

Consider computers `ta` and `co`.  `ta`'s connections include `co`, but not
`ta`.  So, their intersection will not include `ta`.  By the same logic, `co`'s
connections include `ta`, but not `co`.  So, their intersection will not include
`co` either.  Any third computer that they are both connected with, however,
will appear in the intersection.

I built strings for each trio of computers by concatenating their names in
alphabetical order, then used `#uniq` to de-dupe this list.  These were all the
trios with at least one computer starting with `t`.

## Puzzle 2


