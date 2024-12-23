# [Day 21](https://adventofcode.com/2024/day/21)

## Puzzle 1

Wasted a lot of time because I didn't read the problem statement carefully
enough.  I thought I could move over the gap in the corner of the keypad, and
it messed up all my attempts.  Silly me thought I had found a bug in the puzzle
because I was finding sequences shorter than the ones in the example.  Sequences
that were going over the gap, which are illegal.

Eventually, I went to reddit and found one discussion that mentioned "special
rules" for avoiding the corner.  That was all I needed.

I built abstractions for `NumericalKeypad` and `DirectionalKeypad`, along with
some helper classes for `Coord` and `Vector` to move across the keypads.  The
logic got to have so many corner cases (pun intended) that I had to write some
tests for them.

The main method, `#press_sequence`, is kinda named backwards.  You give it a
sequence that you want to enter on that keypad, and it returns all the movement
permutations that would result in that sequence.  Naming is hard and I'm tired.
The `Keypad#coalesce` method is possibly misnamed, too.

## Puzzle 2

Instead of 2 `DirectionalKeypad`, there are now 25.

I refactored `Keypad` so I can chain them instead, à la Decorator design
pattern.  I also added a cache in each one to memoize repeated calculations.

It works just file for Puzzle 1, with one `NumericalKeypad` and two
`DirectionalKeypad`, but it seems to get stuck in a loop the moment I add a
third `DirectionalKeypad`.

_UPDATE:_ I've identified the loop as the `#coalesce` method.  I didn't need to
return the strings of movements themselves, and just the length of the shortest
one.  This way, I don't need the `#coalesce` method at all and the entire thing,
with 25 `DirectionalKeypad` instances, runs in about **62ms**.

## Tests

I wrote some tests to help me nail down the logic.  You can run them with:

```bash
./bin/rspec specs
```

Or see the full list of tests with:

```bash
./bin/rspec --format documentation specs

> You may need to install RSpec with:
> 
> ```bash
> bundle install
> bundle binstubs --all
> ```
