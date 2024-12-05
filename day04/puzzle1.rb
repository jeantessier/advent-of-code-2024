#!/usr/bin/env ruby

# Login to https://adventofcode.com/2024/day/4/input to download 'input.txt'.

# lines = readlines
# lines = File.readlines('sample.txt') # Answer: 18 (in 57 ms)
lines = File.readlines('input.txt') # Answer: 2633 (in 99 ms)

puts 'Initial State'
puts '-------------'
puts lines
puts

def read_east(lines, x, y)
  return '' unless (y + 3) < lines.first.size

  4.times.collect { |n| lines[x][y + n] }.join
end

def read_northeast(lines, x, y)
  return '' unless (x - 3) >= 0 and (y + 3) < lines.first.size

  4.times.collect { |n| lines[x - n][y + n] }.join
end

def read_north(lines, x, y)
  return '' unless (x - 3) >= 0

  4.times.collect { |n| lines[x - n][y] }.join
end

def read_northwest(lines, x, y)
  return '' unless (x - 3) >= 0 and (y - 3) >= 0

  4.times.collect { |n| lines[x - n][y - n] }.join
end

def read_west(lines, x, y)
  return '' unless (y - 3) >= 0

  4.times.collect { |n| lines[x][y - n] }.join
end

def read_southwest(lines, x, y)
  return '' unless (x + 3) < lines.size and (y - 3) >= 0

  4.times.collect { |n| lines[x + n][y - n] }.join
end

def read_south(lines, x, y)
  return '' unless (x + 3) < lines.size

  4.times.collect { |n| lines[x + n][y] }.join
end

def read_southeast(lines, x, y)
  return '' unless (x + 3) < lines.size and (y + 3) < lines.first.size

  4.times.collect { |n| lines[x + n][y + n] }.join
end

occurrences = 0

(0...lines.size).each do |x|
  (0...lines.first.size).each do |y|
    next unless lines[x][y] == 'X'

    occurrences += 1 if read_east(lines, x, y) == 'XMAS'
    occurrences += 1 if read_northeast(lines, x, y) == 'XMAS'
    occurrences += 1 if read_north(lines, x, y) == 'XMAS'
    occurrences += 1 if read_northwest(lines, x, y) == 'XMAS'
    occurrences += 1 if read_west(lines, x, y) == 'XMAS'
    occurrences += 1 if read_southwest(lines, x, y) == 'XMAS'
    occurrences += 1 if read_south(lines, x, y) == 'XMAS'
    occurrences += 1 if read_southeast(lines, x, y) == 'XMAS'
  end
end

puts "occurrences: #{occurrences}"
