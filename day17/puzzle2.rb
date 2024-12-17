#!/usr/bin/env ruby

require './reverse_computer'

# Login to https://adventofcode.com/2024/day/17/input to download 'input.txt'.

# lines = readlines
# lines = File.readlines('sample2.txt', chomp: true) # Answer: 117440 (in 59 ms)
# A_OVERRIDE = 117_440
lines = File.readlines('input.txt', chomp: true) # Answer: ?? (in ?? ms)
A_OVERRIDE = nil

separators = lines.map.with_index { |line, i| line.empty? ? i : nil }.compact

PROGRAM_REGEX = /Program: (?<program>(\d+,)*\d+)/

match = PROGRAM_REGEX.match(lines[separators.first + 1])
if match
  program = match[:program].split(',').map(&:to_i)

  reverse_computer = ReverseComputer.new(program)
  reverse_computer.reverse_run(program)

  puts "Register A: #{reverse_computer.a}"
end
