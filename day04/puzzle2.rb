#!/usr/bin/env ruby

# lines = readlines
# lines = File.readlines('sample.txt') # Answer: 9 (in 62 ms)
lines = File.readlines('input.txt') # Answer: 1936 (in 67 ms)

puts 'Initial State'
puts '-------------'
puts lines
puts

occurrences = 0

(1...(lines.size - 1)).each do |x|
  (1...(lines.first.size - 1)).each do |y|
    next unless lines[x][y] == 'A'

    diagonal1 = lines[x - 1][y - 1] + lines[x][y] + lines[x + 1][y + 1]
    diagonal2 = lines[x - 1][y + 1] + lines[x][y] + lines[x + 1][y - 1]

    occurrences += 1 if [ 'MAS', 'SAM' ].include?(diagonal1) and [ 'MAS', 'SAM' ].include?(diagonal2)
  end
end

puts "occurrences: #{occurrences}"
