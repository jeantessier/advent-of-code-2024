#!/usr/bin/env ruby

# Login to https://adventofcode.com/2024/day/19/input to download 'input.txt'.

CONSTANTS = {
  # file: 'sample.txt', threshold: 10, answer: 10, time: '50 ms',
  file: 'input.txt', threshold: 100, answer: 1332, time: '121 ms',
}

lines = File.readlines(CONSTANTS[:file], chomp:true)

# Renders the map (on *STDOUT* by default)
def print_map(map, out = $stdout)
  map.each do |row|
    out.puts row.join
  end
end

map = lines.map do |line|
  line.split('')
end

puts 'Map'
puts '---'
print_map(map)
puts

Coord = Data.define(:map, :x, :y) do
  def up = Coord.new(map, x - 1, y)
  def right = Coord.new(map, x, y + 1)
  def down = Coord.new(map, x + 1, y)
  def left = Coord.new(map, x, y - 1)

  def neighbors
    [up, right, down, left].select(&:track?)
  end

  def walls
    [up, right, down, left].select(&:valid?).reject(&:track?)
  end

  def track?
    map[x][y] != '#'
  end

  def valid?
    x.respond_to? && x < (map.size - 1) && y.positive? && y < (map.first.size - 1)
  end

  def -(other)
    case
    when x - 1 == other.x && y == other.y then :up
    when x == other.x && y + 1 == other.y then :right
    when x + 1 == other.x && y == other.y then :down
    when x == other.x && y - 1 == other.y then :left
    else raise "Invalid difference between #{self} and #{other}"
    end
  end

  def to_s
    "(#{x}, #{y})"
  end
end

start = map.collect.with_index do |row, x|
  row.collect.with_index do |cell, y|
    Coord.new(map, x, y) if cell == 'S'
  end
end.flatten.compact.first

finish = map.collect.with_index do |row, x|
  row.collect.with_index do |cell, y|
    Coord.new(map, x, y) if cell == 'E'
  end
end.flatten.compact.first

puts "start: #{start}"
puts "finish: #{finish}"
puts

race_times = map.collect { |row| Array.new(row.size) }

previous_position = nil
current_position = finish

race_times[current_position.x][current_position.y] = 0

until current_position == start
  neighbors = current_position.neighbors
  # puts "current_position: #{current_position}: neighbors: #{neighbors}"

  next_position = neighbors.reject { |neighbor| neighbor == previous_position }.first
  # puts "current_position: #{current_position}: next_position: #{next_position}"

  race_times[next_position.x][next_position.y] = race_times[current_position.x][current_position.y] + 1

  previous_position = current_position
  current_position = next_position
end

puts 'Baseline'
puts '--------'
puts race_times[start.x][start.y]
puts

interior_walls = (1...(map.size - 1)).collect do |x|
  (1...(map.first.size - 1)).collect do |y|
    Coord.new(map, x, y) if map[x][y] == '#'
  end
end.flatten.compact

puts "Interior Walls (#{interior_walls.size})"
puts '--------------'
# puts interior_walls
puts

savings = interior_walls
            .map { |interior_wall| interior_wall.neighbors }
            .select { |neighbors| neighbors.size > 1 }
            .map { |neighbors| neighbors.product(neighbors) }
            .flatten(1)
            .select { |n1, n2| (n1.x != n2.x && n1.y == n2.y) || (n1.x == n2.x && n1.y != n2.y) }
            .map { |neighbors| neighbors.map { |coord| race_times[coord.x][coord.y] } }
            .select { |t1, t2| t1 < t2 }
            .collect { |t1, t2| t2 - t1 - 2 }

puts "Savings (#{savings.size})"
puts '-------'
# puts savings
puts

histo = savings.reduce(Hash.new(0)) { |hash, n| hash[n] += 1; hash }

puts "Savings Histogram (#{histo.size})"
puts '-----------------'
# histo.sort.each do |k, v|
#   puts "  There are #{v} cheats that save #{k} picoseconds."
# end
puts

answer = histo
           .select { |saving, count| saving >= CONSTANTS[:threshold] }
           .sum { |savings, count| count }

puts "Answer: #{answer}"
