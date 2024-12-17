#!/usr/bin/env ruby

require './computer'

# Login to https://adventofcode.com/2024/day/17/input to download 'input.txt'.

# lines = readlines
# lines = File.readlines('sample1.txt', chomp: true) # Answer: 4,6,3,5,6,3,5,2,1,0 (in 56 ms)
lines = File.readlines('input.txt', chomp: true) # Answer: 5,0,3,5,7,6,1,5,4 (in 60 ms)

separators = lines.map.with_index { |line, i| line.empty? ? i : nil }.compact

REGISTER_REGEX = /Register (?<register>\w): (?<value>\d+)/

init_state = lines[0...(separators.first)]
               .map { |line| REGISTER_REGEX.match(line) }
               .compact
               .reduce({}) do |acc, m|
                 acc[m[:register]] = m[:value].to_i
                 acc
               end

computer = Computer.new(init_state['A'], init_state['B'], init_state['C'])

PROGRAM_REGEX = /Program: (?<program>(\d+,)*\d+)/

match = PROGRAM_REGEX.match(lines[separators.first + 1])
if match
  computer.run(match[:program].split(',').map(&:to_i))
end

puts "Output: #{computer.output.join(',')}"
