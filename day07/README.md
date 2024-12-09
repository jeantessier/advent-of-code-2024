# [Day 07](https://adventofcode.com/2024/day/7)

## Puzzle 01

A simple brute force approach.  I used recursion to generate a list of all
possible combinations of operators.  At first, I drove the recursion from the
head of the list of operands, which yielded a right-to-left evaluation.  That
was quick to fix.

## Puzzle 02

I just added one more possible operator and it worked.  It took much longer to
run, though.  With `n` operands, the solution for Puzzle 1 evaluated
**2<sup>n</sup>** combinations.  With the extra operator, Puzzle 2 evaluated
**3<sup>n</sup>** combinations.

The most operands in the input equations is 12.  2<sup>12</sup> is **4096**
versus 3<sup>12</sup> which is **531441**.  That's two orders of magnitude
higher.

One obvious optimization would be to stop the recursion when we find the first
correct combination of operators.  In Ruby, a call to `return` from inside a
block exits the enclosing method.  I would have to pass the expected
`test_result` to my `#evaluate` method and return a boolean from within the
call to `#map`.  But this would make the recursion much more complicated. 
