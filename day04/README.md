# Day 04

## Puzzle 1

At first, I figured I could look at each character, and based on which letter it
was, look for `XMAS` in all 8 compass points: E, NE, N, NW, W, SW, S, and SE.  I
would count each occurrence 4 times, but I could divide the total by 4 to get me
an answer.  Then, I realized I only needed to locate `X` and search from there.
This way, there was no over counting.

The reading methods each only returns 4 characters.  If it is too close to the
edge to get 4 characters, they return an empty string.
