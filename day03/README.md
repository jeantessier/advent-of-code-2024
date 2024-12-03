# Day 03

Solved using the magic of regular expressions.  Puzzle 1 was really simple.  I
used Ruby's `String#scan` to run the regex over the entire input and multiply
numbers in place.  Puzzle 2 was a little more challenging as I had to extract
all instructions first, filter out the disabled ones, and then do the
multiplications.  Wrangling all the regexes can be frustrating.
