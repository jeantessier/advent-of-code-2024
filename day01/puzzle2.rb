#!/usr/bin/env ruby

# Login to https://adventofcode.com/2024/day/1/input to download 'input.txt'.

# lines = readlines
# lines = File.readlines("sample.txt") # Answer: 31 (in 64 ms)
lines = File.readlines("input.txt") # Answer: 20719933 (in 66 ms)

original_lists = lines.map { |line| line.split(/\s+/).map(&:to_i) }

first_list = original_lists.map { |lists| lists[0] }

frequencies = original_lists.map { |list| list[1] }.reduce(Hash.new(0)) { |hash, item| hash[item] += 1; hash }

similarity_scores = first_list.map { |value| value * frequencies[value] }

similarity_score = similarity_scores.sum

puts "total similarity score: #{similarity_score}"
