#!/usr/bin/env ruby

# Login to https://adventofcode.com/2024/day/2/input to download 'input.txt'.

# lines = readlines
# lines = File.readlines("sample.txt", chomp: true) # Answer: 2 (in 54 ms)
lines = File.readlines("input.txt", chomp: true) # Answer: 559 (in 89 ms)

reports = lines.map { |line| line.split(/\s+/).map(&:to_i) }

safe_reports = reports.find_all do |report|
  adjacent_diffs = report.each_cons(2).map { |level_a, level_b| level_a - level_b }

  all_decreasing = adjacent_diffs.all? { |diff| diff <= 0 }
  all_increasing = adjacent_diffs.all? { |diff| diff >= 0 }
  within_tolereances = adjacent_diffs.map(&:abs).all? { |diff| 1 <= diff && diff <= 3 }

  (all_increasing || all_decreasing) && within_tolereances
end

total_safe = safe_reports.size

puts "total safe: #{total_safe}"
