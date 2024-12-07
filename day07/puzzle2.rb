#!/usr/bin/env ruby

# Login to https://adventofcode.com/2024/day/7/input to download 'input.txt'.

# lines = readlines
# lines = File.readlines('sample.txt') # Answer: 11387 (in 56 ms)
lines = File.readlines('input.txt') # Answer: 223472064194845 (in 3,472 ms)

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
      "#{partial}#{operands[-1]}".to_i,
    ]
  end.flatten
end

valid_equations = lines
                  .map { |line| EQUATION_REGEX.match(line) }
                  .compact
                  .find_all do |match|
                    test_result = match[:test_result].to_i
                    operands = match[:operands].split.map(&:to_i)
                    evaluate(operands).any? { |result| result == test_result }
                  end

puts 'Valid Equations'
puts '---------------'
valid_equations.each { |equation| puts equation }
puts

total = valid_equations
        .map { |match| match[:test_result] }
        .map(&:to_i)
        .sum

puts "Total: #{total}"
