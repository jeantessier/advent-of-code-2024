#!/usr/bin/env ruby

# lines = readlines
# lines = File.readlines("sample.txt") # Answer: 2 (in 54 ms)
lines = File.readlines("input.txt") # Answer: 559 (in 89 ms)

reports = lines.map { |line| line.split(/\s+/).map(&:to_i) }

safe_reports = reports.find_all do |report|
  puts "report: #{report}"

  adjacent_diffs = report[..-2].zip(report[1..]).map { |level_a, level_b| level_a - level_b }

  puts "adjacent_diffs: #{adjacent_diffs}"

  all_decreasing = adjacent_diffs.all? { |diff| diff <= 0 }
  puts "all_decreasing: #{all_decreasing}"
  all_increasing = adjacent_diffs.all? { |diff| diff >= 0 }
  puts "all_increasing: #{all_increasing}"
  within_tolereances = adjacent_diffs.map(&:abs).all? { |diff| 1 <= diff && diff <= 3 }
  puts "within_tolerances: #{within_tolereances}"

  safe = (all_increasing || all_decreasing) && within_tolereances

  puts "safe?: #{safe}"
  puts

  safe
end

total_safe = safe_reports.size

puts "total safe: #{total_safe}"
