#!/usr/bin/env ruby

# lines = readlines
# lines = File.readlines("sample1.txt") # Answer: 161 (in 51 ms)
lines = File.readlines("input.txt") # Answer: 160672468 (in 59 ms)

REGEX = /mul\((\d{1,3}),(\d{1,3})\)/

multiplications = lines.map do |line|
  line.scan(REGEX).map do |n1, n2|
    n1.to_i * n2.to_i
  end
end

total = multiplications.flatten.sum

puts "total: #{total}"
