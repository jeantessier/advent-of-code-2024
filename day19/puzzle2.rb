#!/usr/bin/env ruby

# Login to https://adventofcode.com/2024/day/19/input to download 'input.txt'.

# lines = readlines
# lines = File.readlines('sample.txt', chomp: true) # Answer: 16 (in 43 ms)
lines = File.readlines('input.txt', chomp: true) # Answer: 1016700771200474 (in 267 ms)

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

DESIGN_CACHE = {}
def count_possibilities(design, towels)
  return 1 if design.empty?
  return DESIGN_CACHE[design] if DESIGN_CACHE.include?(design)

  count = towels
    .select { |towel| design.start_with?(towel) }
    .collect { |towel| count_possibilities(design[(towel.size)..], towels) }
    .sum

  DESIGN_CACHE[design] = count

  count
end

possible_designs = wanted_designs.map do |design|
  count_possibilities(design, towels)
end

puts 'Possible Designs'
puts '----------------'
puts possible_designs
puts

answer = possible_designs.sum

puts "Answer: #{answer}"
