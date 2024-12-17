#!/usr/bin/env ruby

# Login to https://adventofcode.com/2024/day/7/input to download 'input.txt'.

# lines = readlines
# lines = File.readlines('sample.txt', chomp: true) # Answer: 3749 (in 56 ms)
lines = File.readlines('input.txt', chomp: true) # Answer: 975671981569 (in 116 ms)

EQUATION_REGEX = /(?<test_result>\d+): (?<operands>(\d+\s+)*\d+)/

# Returns all variations of operands with :+ and :* operators,
# with operators evaluated from left-to-right regardless of the operator.
def evaluate(operands)
  throw 'Invalid operands' if operands.empty?
  return operands[0..0] if operands.size == 1

  evaluate(operands[..-2]).map do |partial|
    [
      operands[-1] + partial,
      operands[-1] * partial,
    ]
  end.flatten
end

valid_equations = lines
                  .map { |line| EQUATION_REGEX.match(line) }
                  .compact
                  .find_all do |match|
                    test_result = match[:test_value].to_i
                    operands = match[:operands].split.map(&:to_i)
                    evaluate(operands).any? { |result| result == test_result }
                  end

puts 'Valid Equations'
puts '---------------'
valid_equations.each { |equation| puts equation }
puts

total = valid_equations
        .map { |match| match[:test_value] }
        .map(&:to_i)
        .sum

puts "Total: #{total}"
