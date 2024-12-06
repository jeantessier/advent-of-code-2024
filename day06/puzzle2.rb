#!/usr/bin/env ruby

# Login to https://adventofcode.com/2024/day/6/input to download 'input.txt'.

# lines = readlines
# lines = File.readlines('sample.txt') # Answer: 6 (in 50 ms)
lines = File.readlines('input.txt') # Answer: 1721 (in 38,437 ms)

# Renders the map (on *STDOUT* by default)
def print_map(map, out = $stdout)
  map.each do |row|
    out.puts row.join
  end
end

map = lines.map do |line|
  line.chomp.split('')
end

x_range = 0...map.size
y_range = 0...map.first.size

puts 'Map'
puts '---'
print_map(map)
puts

def next_direction(direction)
  case direction
  when [-1,  0] then [ 0,  1]
  when [ 0,  1] then [ 1,  0]
  when [ 1,  0] then [ 0, -1]
  when [ 0, -1] then [-1,  0]
  else throw Exception.new 'Invalid direction'
  end
end

def loop?(map, x_range, y_range)
  record = Array.new(x_range.size) { |_| Array.new(y_range.size) { |_| [] } }

  x = map.find_index { |row| row.include?('^') }
  y = map[x].find_index { |cell| cell == '^' }
  direction = [-1, 0]

  obstacles = %w[# O]

  while x_range.include?(x) && y_range.include?(y) && !record[x][y].include?(direction)
    record[x][y] << direction

    next_x = x + direction[0]
    next_y = y + direction[1]
    if x_range.include?(next_x) && y_range.include?(next_y) && obstacles.include?(map[next_x][next_y])
      direction = next_direction(direction)
    else
      x = next_x
      y = next_y
    end
  end

  x_range.include?(x) && y_range.include?(y)
end

total = x_range.sum do |x|
  y_range.find_all do |y|
    copy = map.map { |row| row.clone }
    copy[x][y] = 'O'

    is_loop = map[x][y] == '.' && loop?(copy, x_range, y_range)

    puts "[#{x}, #{y}] #{is_loop ? '***' : ''}"

    is_loop
  end.size
end

puts
puts "Total: #{total}"
