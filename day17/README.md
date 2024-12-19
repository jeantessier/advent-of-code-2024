# [Day 17](https://adventofcode.com/2024/day/17)

## Puzzle 01

Wrote a virtual machine in class `Computer`.  It maps opcodes to Ruby symbols
and then uses `#public_send` to invoke methods corresponding to each
instruction.  The instructions take care of moving the instruction pointer.  I
added traces to show the program executing and the machine's state after each
instruction.

## Puzzle 02

I thought of reversing my virtual machine to make it run the code in reverse.
But, there is too much uncertainty.  I cannot reverse an arbitrary `jump`
instruction.  It would have to be specific to the program, knowing that there
is a single `jump` instruction that goes to 0, so if the instruction pointer is
`0`, that might mean going to this `jump` instruction next.

The program looks at `Register A` 3 bits at a time.  The minimal value to
unshift into `Register A` should be `000`, but we go through a jump, some of the
other bits must have been set.  Since `Register A` was `0` at the end of the
program, this means we need to insert at least one `1` somewhere.  That's a lot
of flimsy logic to keep track of.  And I haven't talked about `xor`'ing and 
copying arbitrary bits from `Register A` to `Register C`, etc.

I'm still burned out from the effort for Day 16.  I'm giving up on Puzzle 2.

One more attempt.  I streamlined `Computer` instructions to rewrite them as
bitwise operations.  Dividing by powers of 2 is equivalent to shifting bits
right.  Modulo 8 is equivalent to keeping only the last three bits.  I was
hoping it would be easier to reverse instructions this way.  I got it to work
with the sample data, since that program does not use `Register C`.

I need to seed `Register C` for it to work with the actual input.  Running `cdv`
in reverse pushes the bits in `Register C` into the upper bits of `Register A`.
The `7,5` instruction (`cdv B`) shifts the value from `Register C` by a number
of bits given by `Register B` and copies them to `Register A`.  It preserves the
lower bits of `Register A`.

At the end of the program, we know `Register A` is `0` because the last
instruction, the jump, didn't jump and caused the `HALT`.  We also know that
`Register B` is also `0` because the last thing we did was output that register
and the last output value is `0`.  That leaves `Register C`.  We also know that
at the beginning of the program, `Register B` and `Register C` were initialized
to `0`.  So, reversing the program should drive these registers to `0`.

I'm giving up, again.  There are too many possible values for `Register B` and
`Register C` to consider.

Looking at discussions, people are running numbers through their simulator and
gradually build a solution that returns tails of the expected output.  The
computer looks at 3 bits at a time, so I can build octal numbers (in base 8,
with digits `0..7`).

For example, for a single digit that returns the last number in the output, `0`:

```
candidate 00: Register A: 0 --> Output: 4
candidate 01: Register A: 1 --> Output: 4
candidate 02: Register A: 2 --> Output: 6
candidate 03: Register A: 3 --> Output: 7
candidate 04: Register A: 4 --> Output: 0 *****
candidate 05: Register A: 5 --> Output: 1
candidate 06: Register A: 6 --> Output: 2
candidate 07: Register A: 7 --> Output: 3
```

Sometimes, there might be multiple solutions.  With the two digits starting with
`4`, the second digits `5` and `7` both produce the output `3, 0`.

```
candidate 040: Register A: 32 --> Output: 4,0
candidate 041: Register A: 33 --> Output: 4,0
candidate 042: Register A: 34 --> Output: 2,0
candidate 043: Register A: 35 --> Output: 7,0
candidate 044: Register A: 36 --> Output: 1,0
candidate 045: Register A: 37 --> Output: 3,0 *****
candidate 046: Register A: 38 --> Output: 2,0
candidate 047: Register A: 39 --> Output: 3,0 *****
```

So, the next step will attempt `0450..0457` and `0470..0477`, and only one value
produces the expected output `5, 3, 0`: the value `0453`.

Building up to 16 digits, at each level keeping only candidates that produce a
growing tail of the expected output, I ended up with the following candidates.
Each one will produce the correct output, but the first one is the smallest
number to do so.  All in **131ms**.

```
04532017064474665 ==> 164516454365621 *****
04532206273267275 ==> 164532461596349
04532206273267675 ==> 164532461596605
04532216273267275 ==> 164533535338173
04532216273267675 ==> 164533535338429
04532223533267275 ==> 164534248369853
04532223533267675 ==> 164534248370109
04532226273267275 ==> 164534609079997
04532226273267675 ==> 164534609080253
04532246273267275 ==> 164536756563645
04532246273267675 ==> 164536756563901
04532246673267275 ==> 164536823672509
04532246673267675 ==> 164536823672765
```

> At first, I was looking for a value of `Register A` that gave the **first**
> values of the output, instead of the last ones.

Many thanks to
[this thread](https://www.reddit.com/r/adventofcode/comments/1hgo81r/2024_day_17_genuinely_enjoyed_this/)
and
[this thread](https://www.reddit.com/r/adventofcode/comments/1hg38ah/2024_day_17_solutions/)
on Reddit for guiding me to a solution.
