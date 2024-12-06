# Day 05

## Puzzle 1

This was pretty straight-forward.  Go through updates, find all relevant rules
using `#find_all` (aka `#select`) and use `#all?` to make sure they are all met.

## Puzzle 2

Finding the incorrect updates was simple.  Fixing them was something else.

My first naive attempt was to swap values when a rule was not being met.  It
worked for the sample data, but the real input got into an endless loop of
constantly swapping the same handful of values.

I figured I would have to fix them in one pass, using some algorithm to figure
out the correct order.  I took inspiration from the problem description and
computed, for each page in an update, which other pages needed to be after it.
Then, I just sorted based on the number of following pages.  Pages with the more
pages following them came before pages with fewer.  I didn't look at the
specific following pages, just how many of them there were.  This gave me the
correct answer, so I left it at that.

I don't feel great about, essentially, stumbling unto the right answer by using
a wild guess, an unverified assumption.  But, it will have to do for today.
