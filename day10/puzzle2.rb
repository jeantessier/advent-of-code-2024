#!/usr/bin/env ruby

require './coord'

# Login to https://adventofcode.com/2024/day/10/input to download 'input.txt'.

# lines = readlines
# lines = File.readlines('sample.txt') # Answer: 81 (in 48 ms)
lines = File.readlines('input.txt') # Answer: 1210 (in 67 ms)

# Renders the map (on *STDOUT* by default)
def print_map(map, out = $stdout)
  map.each do |row|
    out.puts row.join
  end
end

def print_trailheads(map, out = $stdout)
  map.each do |row|
    out.puts row.map { |cell| cell.positive? ? '.' : '0' }.join
  end
end

map = lines.map do |line|
  line.chomp.split('').map(&:to_i)
end

puts 'Map'
puts '---'
print_map(map)
puts

x_range = 0...map.size
y_range = 0...map.first.size

puts 'Ranges'
puts '------'
puts "x_range: #{x_range}"
puts "y_range: #{y_range}"
puts

trailheads = x_range.collect do |x|
  y_range.collect do |y|
    map[x][y] == 0 ? Coord.new(x, y, x_range, y_range) : nil
  end
end.flatten.compact

puts 'trailheads'
puts '----------'
print_trailheads(map)
trailheads.each { |coord| puts coord }
puts

def hike(map, coord)
  return [ coord ] if map[coord.x][coord.y] == 9

  [
    coord.up,
    coord.right,
    coord.down,
    coord.left,
  ]
    .select(&:valid?)
    .select { |c| map[c.x][c.y] == map[coord.x][coord.y] + 1 }
    .collect { |c| hike(map, c) }
    .flatten
end

ratings = trailheads.map do |trailhead|
  hike(map, trailhead).size
end

total = ratings.sum

puts
puts "Total: #{total}"
