#!/usr/bin/env ruby

# Login to https://adventofcode.com/2024/day/5/input to download 'input.txt'.

# lines = readlines
# lines = File.readlines('sample.txt') # Answer: 143 (in 57 ms)
lines = File.readlines('input.txt') # Answer: 5639 (in 86 ms)

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

ready_updates = updates.find_all do |update|
  rules
    .find_all { |rule| update.include?(rule[0]) && update.include?(rule[1]) }
    .all? do |rule|
      pos1 = update.find_index(rule[0])
      pos2 = update.find_index(rule[1])

      pos1 < pos2
    end
end

middle_pages = ready_updates.map { |update| update[update.size / 2] }

total = middle_pages.sum

puts "Total: #{total}"
