#!/usr/bin/env ruby

# Login to https://adventofcode.com/2024/day/19/input to download 'input.txt'.

# lines = readlines
# lines = File.readlines('sample.txt', chomp: true) # Answer: 6 (in 39 ms)
lines = File.readlines('input.txt', chomp: true) # Answer: 213 (in 92 ms)

separators = lines.map.with_index { |line, i| line.empty? ? i : nil }.compact

towels = lines[0...(separators.first)].map { |line| line.split(', ') }.flatten

puts 'Towels'
puts '------'
puts towels
puts

wanted_designs = lines[(separators.first + 1)..]

puts 'Wanted Designs'
puts '--------------'
puts wanted_designs
puts

def possible?(design, towels)
  return true if design.empty?

  towels.any? do |towel|
    design.start_with?(towel) && possible?(design[(towel.size)..], towels)
  end
end

possible_designs = wanted_designs.select do |design|
  possible?(design, towels)
end

puts 'Possible Designs'
puts '----------------'
puts possible_designs
puts

answer = possible_designs.size

puts "Answer: #{answer}"
