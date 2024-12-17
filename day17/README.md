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
