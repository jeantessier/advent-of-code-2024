#!/usr/bin/env ruby

require './machine'

# Login to https://adventofcode.com/2024/day/13/input to download 'input.txt'.

# lines = readlines
# lines = File.readlines('sample.txt') # Answer: 875318608908 (in 62 ms)
lines = File.readlines('input.txt') # Answer: 78101482023732 (in 68 ms)

separators = lines.map(&:chomp).map.with_index { |line, i| line.empty? ? i : nil }.compact

machine_ranges = ([-1] + separators + [lines.size]).each_cons(2).map { |pair| (pair.first + 1)...(pair.last) }

machine_configurations = machine_ranges.map { |range| lines[range] }

puts 'Machine Configurations'
puts '----------------------'
machine_configurations.each do |config|
  puts config
  puts
end

machines = machine_configurations.map { |configuration| Machine.new(configuration, 10_000_000_000_000) }

puts 'Valid Machine'
puts '-------------'
puts machines.map(&:valid?)
puts

tokens = machines.select(&:valid?).compact.map(&:minimum_tokens)

puts 'Tokens'
puts '------'
puts tokens
puts

total = tokens.sum

puts "Total: #{total}"
