# Day 07

## Puzzle 01

A simple brute force approach.  I used recursion to generate a list of all
possible combination of operators.  At first, I drove the recursion from the
head of the list of operands, which yielded a right-to-left evaluation.  That
was quick to fix.

## Puzzle 02

I just added one more possible operator and it worked.  It took much longer,
though.  With `n` operands, the solution for Puzzle 1 evaluated `2**n`
combinations.  With the extra operator, Puzzle 2 evaluated `3**n` combinations.

The most operands in the input equations is 12.  2^12 is **4096** versus 3^12
which is **531441**.  That's two orders of magnitude higher.

One obvious optimization would be to stop the recursion when we find the first
correct combination of operators.  In Ruby, a call to `return` from inside a
block exits the enclosing method.  I would have to pass the expected
`test_result` to my `#evaluate` method and return a boolean from within the
call to `#map`.  But this would make the recursion much more complicated. 
