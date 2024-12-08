# Day 08

## Puzzle 01

Relatively quick.  Go though all pairs of antennas finding all antennas for a
given frequency and using Ruby's `#Array.product` to generate all pairs of
antennas.  I had to remove "pairs" of an antenna with itself.  It would return
each pair twice, once `[A, B]` and once `[B, A]`.  (I thought I could just
divide by 2 at the end to make up for it.)  For each pair, I found the bounding
box and then went along the correct diagonal for find the antinodes.

The last step was to remove duplicates (which took care of handling each pair
twice) and remove antinodes that were outside the map.

## Puzzle 02

I used the unbounded generator `(0..).lazy` to walk the diagonal of each
bounding box until I walked off the edge of the map.  Remove duplicates and I
was done.
