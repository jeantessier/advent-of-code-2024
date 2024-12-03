# Day 03

Solved using the magic of regular expressions.  Puzzle 1 was really simple.  I
used Ruby's `String#scan` to run the regex over the entire input and multiply
numbers in place.  Puzzle 2 was a little more challenging as I had to extract
all instructions first, filter out the disabled ones, and then do the
multiplications.  Wrangling all the regexes can be frustrating.

I could have read the inputs as a single string, but I've been starting all my
puzzles with `File.readlines` automatically for some time.  Most puzzles have
line-based inputs, so it works out fine.  And, it saves me from having to think
about file operations.  In this case, it meant one more level of `#map` and
`#flatten`, which complicate the code a little.

Out of curiosity, I tried to simplify it.

```ruby
# text = File.new("sample1.txt").read
text = File.new("input.txt").read

REGEX = /mul\((\d{1,3}),(\d{1,3})\)/

total = text.scan(REGEX).map { |n1, n2| n1.to_i * n2.to_i }.sum

puts "total: #{total}"
```

I even got it down to a one-liner:

```ruby
puts File.new("input.txt").read.scan(/mul\((\d{1,3}),(\d{1,3})\)/).map { |n1, n2| n1.to_i * n2.to_i }.sum
```
