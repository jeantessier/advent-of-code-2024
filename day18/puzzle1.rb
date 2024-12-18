#!/usr/bin/env ruby

# Login to https://adventofcode.com/2024/day/18/input to download 'input.txt'.

CONSTANTS = {
  # file: 'sample.txt', x_range: 0..6, y_range: 0..6, corruption_range: 0...12, answer: 22, time: '57 ms',
  file: 'input.txt', x_range: 0..70, y_range: 0..70, corruption_range: 0...1024, answer: 284, time: '131 ms',
}

lines = File.readlines(CONSTANTS[:file], chomp:true)

Coord = Data.define(:x, :y) do
  def up = Coord.new(x - 1, y)
  def right = Coord.new(x, y + 1)
  def down = Coord.new(x + 1, y)
  def left = Coord.new(x, y - 1)

  def valid? = CONSTANTS[:x_range].include?(x) && CONSTANTS[:y_range].include?(y)

  def neighbors
    [up, right, down, left].select(&:valid?)
  end

  def to_s
    "(#{x}, #{y})"
  end
end

map = Array.new(CONSTANTS[:y_range].size) do |_|
  Array.new(CONSTANTS[:x_range].size, '.')
end

def print_map(map)
  map.each do |row|
    puts row.join
  end
end

puts 'Map'
puts '---'
print_map(map)
puts

lines[CONSTANTS[:corruption_range]]
  .collect { |line| Coord.new(*(line.split(',').map(&:to_i))) }
  .each { |coord| map[coord.y][coord.x] = '#' }

puts 'Corrupted Map'
puts '-------------'
print_map(map)
puts

distances = Array.new(CONSTANTS[:y_range].size) do |_|
  Array.new(CONSTANTS[:x_range].size)
end

def print_distances(distances)
  distances.each do |row|
    puts '| ' + row.map { |d| d.nil? ? '---' : format('%3d', d) }.join(' | ') + ' |'
  end
end

distances[0][0] = 0

candidates = Coord.new(0, 0).neighbors
until candidates.empty?
  candidate = candidates.shift

  neighbors = candidate.neighbors.reject { |neighbor| map[neighbor.y][neighbor.x] == '#' }.reject { |neighbor| candidates.include?(neighbor) }

  distances[candidate.y][candidate.x] = neighbors.map { |neighbor| distances[neighbor.y][neighbor.x] }.compact.min + 1

  candidates += neighbors.select { |neighbor| distances[neighbor.y][neighbor.x].nil? }
end

puts 'Distances'
puts '---------'
print_distances(distances)
puts

steps = distances.last.last

puts "Steps: #{steps}"
