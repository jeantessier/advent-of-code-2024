#!/usr/bin/env ruby

# Login to https://adventofcode.com/2024/day/6/input to download 'input.txt'.

# lines = readlines
# lines = File.readlines('sample.txt') # Answer: 41 (in 39 ms)
lines = File.readlines('input.txt') # Answer: 4826 (in 62 ms)

# Renders the map (on *STDOUT* by default)
def print_map(map, out = $stdout)
  map.each do |row|
    out.puts row.join
  end
end

def score_map(map)
  map.sum { |row| row.select { |cell| cell == 'X' }.size }
end

map = lines.map do |line|
  line.chomp.split('')
end

puts 'Map'
puts '---'
print_map(map)
puts

x_range = 0...map.size
y_range = 0...map.first.size

puts "x_range: #{x_range}"
puts "y_range: #{y_range}"
puts

x = map.find_index { |row| row.include?('^') }
y = map[x].find_index { |cell| cell == '^' }
direction = [-1, 0]

def next_direction(direction)
  case direction
  when [-1,  0] then [ 0,  1]
  when [ 0,  1] then [ 1,  0]
  when [ 1,  0] then [ 0, -1]
  when [ 0, -1] then [-1,  0]
  else throw Exception.new 'Invalid direction'
  end
end

puts "x: #{x}"
puts "y: #{y}"
puts

while x_range.include?(x) && y_range.include?(y)
  map[x][y] = 'X'
  next_x = x + direction[0]
  next_y = y + direction[1]
  if x_range.include?(next_x) && y_range.include?(next_y) && map[next_x][next_y] == '#'
    direction = next_direction(direction)
    # x += direction[0]
    # y += direction[1]
  else
    x = next_x
    y = next_y
  end
end

puts 'Path'
puts '----'
print_map(map)
puts

score = score_map(map)

puts "Score: #{score}"
