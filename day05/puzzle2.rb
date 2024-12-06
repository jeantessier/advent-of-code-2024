#!/usr/bin/env ruby

# Login to https://adventofcode.com/2024/day/5/input to download 'input.txt'.

# lines = readlines
# lines = File.readlines('sample.txt') # Answer: 123 (in 55 ms)
lines = File.readlines('input.txt') # Answer: 5273 (in 87 ms)

RULE_REGEX = /(\d+)\|(\d+)/
UPDATE_REGEX = /(\d+,)+\d+/

rules = lines
          .map { |line| RULE_REGEX.match(line) }
          .find_all { |match| match }
          .map { |match| [match[1].to_i, match[2].to_i] }

updates = lines
            .map { |line| UPDATE_REGEX.match(line) }
            .find_all { |match| match }
            .map { |match| match[0].split(/,/).map(&:to_i) }

incorrect_updates = updates.find_all do |update|
  rules
    .find_all { |rule| update.include?(rule[0]) && update.include?(rule[1]) }
    .any? do |rule|
      pos1 = update.find_index(rule[0])
      pos2 = update.find_index(rule[1])

      pos1 > pos2
    end
end

puts 'Incorrect Updates'
puts '-----------------'
incorrect_updates.each do |update|
  puts update.inspect
end
puts

condensed_rules = rules.reduce(Hash.new { |h, k| h[k] = [] }) do |memo, rule|
  memo[rule[0]] << rule[1]
  memo
end

fixed_updates = incorrect_updates.map do |update|
  precedence_rules = update.reduce({}) do |memo, page|
    memo[page] = condensed_rules[page].intersection(update)
    memo
  end

  precedence_rules.sort_by { |elem| elem[1].size }.reverse.map { |elem| elem[0] }
end

puts
puts 'Fixed Updates'
puts '-------------'
fixed_updates.each { |update| puts update.inspect }
puts

middle_pages = fixed_updates.map { |update| update[update.size / 2] }

total = middle_pages.sum

puts "Total: #{total}"
