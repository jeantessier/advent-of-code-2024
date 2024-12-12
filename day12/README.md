# [Day 12](https://adventofcode.com/2024/day/12)

## Puzzle 01

I created `Plot` and `Region` abstractions to handle some of the calculations
and boundary checking.  I struggled a bit with merging plots into a region.

The cost of a `Region` is its `#price`, which is based on its `#area` and its
`#perimeter`.

My solution takes over **4s** to run against the input, in part because it goes
over lists of plots over and over again as it tries to connect them into
regions.

## Puzzle 02

The cost of a `Region` is now its `#discounted_price`, which is based on its
`#area` and its `#number_of_sides`.  The script is essentially the same, I just
needed to add two methods to `Region`.

Calculating the number of sides of a shape proved elusive.  I could have counted
angles, but that would require edge detection, which would be complicated.  I
did come up with some interesting shortcuts: shapes with areas of `1` or `2` can
only have **4** sides.  Shapes where all plots are on the same `X` or `Y`
coordinate are a long rectangle with **4** sides.

I went looking for other people's solutions, but most of the ones I could find
didn't show their code.  One person alluded to "used a property of 2D geometric
shapes", but didn't say what it was and I couldn't find anything along this vein
on Google.  I did find
[someone's solution in Java](https://www.twit.community/t/advent-of-code-2024/17694/20)
where they explain they collect all plots that are part of edges and then
combine them into unique edges.  I drew inspiration from this approach in my
`Region#compute_number_of_sides` method.  For example, I gather all the plots
don't have and `#up` neighbor as "top" edges and then merge adjoining segments.
My joining method is straightforward: start with each plot being its own
segment, loop through the other segments, looking for touching segments, and
merge them.  Repeat until nothing changes anymore.  I don't like the infinite
loop, but it was getting late, and I was exhausted.

My solution again takes over **4s** to run against the input, again because of
the logic to connect plots into regions.
