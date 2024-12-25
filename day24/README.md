# [Day 24](https://adventofcode.com/2024/day/24)

## Puzzle 1

I used a small class hierarchy to represent the gates, and looped until all the
gates were determined.

Ruby has helpers to convert octal and hex strings to numbers, but not for
binary.  I used bitwise operations to get the number from the `z??` wires.

## Puzzle 2

X and Y are 45 bits wide, and Z is 46 bits wide.  There are 222 gates.  A brute
force search be in **O(n<sup>8</sup>)** possible swaps.  For `n = 222`, that's
almost 6 quintillions.

If I walk back from the `z??` wires, I can find all the gates that lead to Z.
At least one of them must be swapped, otherwise Z wouldn't change.  However,
when I walk back from Z, I reach each of the 222 gates.

What if I walked back only from the `z??` wires that show broken bits?  The
higher bits connect to very many gates, but the lower bits have increasingly
fewer.  Also, `z22` connects to a single gate, so that one will obviously get
swapped.

Based on this approach (and some inspiration from reading other people's
approaches), I decided to look at four cases:

1. All `x??` and `y??` wires are set to zero.  I'd expect all `z??` to be zero.
2. All `x??` wires are set to zero and all `y??` wires are set to one.  I'd expect `z45` to be zero and the other `z??` wires to be ones.
3. All `x??` wires are set to one and all `y??` wires are set to zero.  I'd expect `z45` to be zero and the other `z??` wires to be ones.
4. All `x??` and `y??` wires are set to one.  I'd expect `z00` to be zero and the other `z??` wires to be ones.

Without swapping any gates, this is what I get:

```
0s + 0s
-------
expected: 0000000000000000000000000000000000000000000000
  actual: 0000000000000000000000000000000000000000000000
 compare:                                               

0s + 1s
-------
expected: 0111111111111111111111111111111111111111111111
  actual: 0111111111111110000000000000001000000011111111
 compare:                ^^^^^^^^^^^^^^^ ^^^^^^^        
first bad bit: 8

1s + 0s
-------
expected: 0111111111111111111111111111111111111111111111
  actual: 0111111111111110000000000000001000000011111111
 compare:                ^^^^^^^^^^^^^^^ ^^^^^^^        
first bad bit: 8

1s + 1s
-------
expected: 1111111111111111111111111111111111111111111110
  actual: 1111111111111111111111111111110111111011111110
 compare:                               ^      ^        
first bad bit: 8
```

It shows a problem starting at `z08`.  Since this is a adder circuit, it makes
sense that higher bits depend on the gates of all the lower bits.  So, if I find
all the gates required up to `z07` and all the gates required up to `z08`, I can
diff the lists to find the gates related to `z08`.  It is likely that one of
them is wrong.

`z00` and `z01` had singular lists of gates, but `z02` through `z07` all had
2x XOR, 2x AND, and 1x OR gates.  `z08` had 3x AND, 1x XOR, and 1x OR gates.

I got the gates for `z07` and drew a diagram of how they are related to each
other.

```
wqm XOR dvd -> z07
vsv OR gpf -> wqm
x06 AND y06 -> vsv
gtq AND npm -> gpf
y07 XOR x07 -> dvd

              x06 A y06       gtq A npm
                  |               |
 x07 X y07       vsv -----O----- gpf
     |                    |
    dvd --------X--------wqm
                |
               z07
```

And I did the same for `z08`.

```
dnn AND dqd -> z08
jmm OR ckq -> dnn
x07 AND y07 -> jmm
dvd AND wqm -> ckq
x08 XOR y08 -> dqd

            x07 A y07       dvd A wqm
                |               |
 x08 X y08     jmm -----O----- ckq
     |                  |
    dqd -------A-------dnn
               |
              z08
```

That `dnn AND dqd -> z08` at the bottom of the diagram should have been a XOR
gate.  I found `dqd XOR dnn -> ffj` in the list of gates, so I tried swapping
`ffj` and `z08`.  My sample computations now worked past bit 8.

```
0s + 0s
-------
expected: 0000000000000000000000000000000000000000000000
  actual: 0000000000000000000000000000000000000000000000
 compare:                                               

0s + 1s
-------
expected: 0111111111111111111111111111111111111111111111
  actual: 0111111111111110000000000000000111111111111111
 compare:                ^^^^^^^^^^^^^^^^               
first bad bit: 15

1s + 0s
-------
expected: 0111111111111111111111111111111111111111111111
  actual: 0111111111111110000000000000000111111111111111
 compare:                ^^^^^^^^^^^^^^^^               
first bad bit: 15

1s + 1s
-------
expected: 1111111111111111111111111111111111111111111110
  actual: 1111111111111111111111111111110111111111111110
 compare:                               ^               
first bad bit: 15
```

I repeated the operation for bits 15, 22, and 31.  Now, having my four pairs,
I was able to get the answer to the puzzle.
