#!/usr/bin/env ruby

# Login to https://adventofcode.com/2024/day/1/input to download 'input.txt'.

# lines = readlines
# lines = File.readlines("sample.txt", chomp: true) # Answer: 11 (in 58 ms)
lines = File.readlines("input.txt", chomp: true) # Answer: 2164381 (in 47 ms)

original_lists = lines.map { |line| line.split(/\s+/).map(&:to_i) }

first_list = original_lists.map { |lists| lists[0] }.sort
second_list = original_lists.map { |lists| lists[1] }.sort

total_diffs = first_list.zip(second_list).map { |pair| pair[0] - pair[1] }.map(&:abs).sum

puts "total diffs: #{total_diffs}"
