# [Day 19](https://adventofcode.com/2024/day/19)

## Puzzle 01

A simple recursive function to check if a pattern or sub-pattern is achievable,
combined with Ruby's `#any?` method.

## Puzzle 02

Changed the recursive function to return a count of possible combinations
instead of just `true`/`false`.  It took forever to run, but I suspected that
sub-patterns came up again and again.  I cached partial results so as not to
recompute them and the whole thing ran in **267ms**.

## Trying to Optimize Puzzle 1

The core of the `#possible?` method looks like this:

```ruby
  towels.any? do |towel|
    design.start_with?(towel) && possible?(design[(towel.size)..], towels)
  end
```

In Puzzle 2, I separated the call to `#start_with?` into its own step for
readability.  I ported this _improvement_ to Puzzle 1 and the core of the
`#possible?` method became:

```ruby
  towels
    .select { |towel| design.start_with?(towel) }
    .any? { |towel| possible?(design[(towel.size)..], towels) }
```

But the running time went from **92ms** to **164ms**.  It almost doubled.

I tried adding the cache, but there was no noticeable difference.  The overhead
of the cache ate any improvement in running time.

> I tried changing the solution to Puzzle 2 to merge the `#select` and
> `#collect` steps, but this made the running time **go up by 10%**.
