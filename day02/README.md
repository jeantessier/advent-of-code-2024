# Day 02

Another one I was able to solve using brute force.  Ruby arrays have a number
of methods to help here: `#zip`, `#map`, `#all?`.

At first, I zipped slices together to create pairs of consecutive elements from
reports:

```ruby
report[..-2].zip(report[1..])
```

But then, I found the `#each_cons` function that does just that.  I replaced the
code above with a simple `report.each_cons(2)` and got the same results with
code that was less cryptic.
