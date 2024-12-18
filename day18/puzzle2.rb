#!/usr/bin/env ruby

require './coord'
require './dijkstra'

# Login to https://adventofcode.com/2024/day/18/input to download 'input.txt'.

CONSTANTS = {
  # file: 'sample.txt', x_range: 0..6, y_range: 0..6, previous_corruption_range: 0...12, next_corruption_range: 12.., answer: '6,1', time: '59 ms',
  file: 'input.txt', x_range: 0..70, y_range: 0..70, previous_corruption_range: 0...1024, next_corruption_range: 1024.., answer: '51,50', time: '55,743 ms',
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

lines[CONSTANTS[:previous_corruption_range]]
  .collect { |line| Coord.new(*(line.split(',').map(&:to_i))) }
  .each { |coord| map[coord.y][coord.x] = '#' }

puts 'Corrupted Map'
puts '-------------'
print_map(map)
puts

byte = lines[CONSTANTS[:next_corruption_range]]
  .collect { |line| Coord.new(*(line.split(',').map(&:to_i))) }
  .find do |coord|
    map[coord.y][coord.x] = '#'
    puts coord
    Dijkstra.dijkstra(map, CONSTANTS[:x_range], CONSTANTS[:x_range]).last.last.nil?
  end

puts
puts "First byte: #{byte}"
