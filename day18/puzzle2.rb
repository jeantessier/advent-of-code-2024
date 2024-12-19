#!/usr/bin/env ruby

require './coord'
require './dijkstra'

# Login to https://adventofcode.com/2024/day/18/input to download 'input.txt'.

CONSTANTS = {
  # file: 'sample.txt', x_range: 0..6, y_range: 0..6, previous_corruption_range: 0...12, next_corruption_range: 12.., answer: '6,1', step: 21, time: '57 ms',
  file: 'input.txt', x_range: 0..70, y_range: 0..70, previous_corruption_range: 0...1024, next_corruption_range: 1024.., answer: '51,50', step: 3043, time: '91 ms',
}

lines = File.readlines(CONSTANTS[:file], chomp:true)

bytes = lines.map { |line| Coord.new(*(line.split(',').map(&:to_i))) }

def build_map
  Array.new(CONSTANTS[:y_range].size) do |_|
    Array.new(CONSTANTS[:x_range].size, '.')
  end
end

def print_map(map)
  map.each do |row|
    puts row.join
  end
end

def build_corrupted_map(bytes)
  map = build_map

  bytes.each { |coord| map[coord.y][coord.x] = '#' }

  map
end

byte = bytes[CONSTANTS[:next_corruption_range]]
  .bsearch do |coord|
    puts coord

    map = build_corrupted_map(bytes[0..(bytes.find_index(coord))])

    Dijkstra.dijkstra(map, CONSTANTS[:x_range], CONSTANTS[:x_range]).last.last.nil?
  end

puts
puts "First byte: #{byte}"
