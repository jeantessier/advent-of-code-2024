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

There are 520 computers and **520!** possible combinations.  But, each computer
has at most 13 connections.  So, that's **520 * 14!** combinations to check,
which is much smaller, but still too much.

I can catch the largest LAN party by any one of its participants.  So, for each
computer, I can try to build the largest fully-connected group from its
connections instead.  That's **520 * 14<sup>2</sup>** connections to check
(actually, about half of that).  For each computer, I find the largest group
that includes it, convert each group to its password, sort by length, and take
the largest.  It ran in **76ms**.

> At first, I was assuming the largest LAN party would include a computer
> starting with `t`.  Because of the problem statement in Puzzle 1.  It turns
> out that wasn't the case.
