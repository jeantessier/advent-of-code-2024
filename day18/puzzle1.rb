#!/usr/bin/env ruby

require './coord'
require './dijkstra'

# Login to https://adventofcode.com/2024/day/18/input to download 'input.txt'.

CONSTANTS = {
  # file: 'sample.txt', x_range: 0..6, y_range: 0..6, corruption_range: 0...12, answer: 22, time: '57 ms',
  file: 'input.txt', x_range: 0..70, y_range: 0..70, corruption_range: 0...1024, answer: 284, time: '131 ms',
}

lines = File.readlines(CONSTANTS[:file], chomp:true)

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

distances = Dijkstra.dijkstra(map, CONSTANTS[:x_range], CONSTANTS[:x_range])

puts 'Distances'
puts '---------'
Dijkstra.print(distances)
puts

steps = distances.last.last

puts "Steps: #{steps}"
