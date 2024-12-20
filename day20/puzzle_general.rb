#!/usr/bin/env ruby

require './coord'

# Login to https://adventofcode.com/2024/day/20/input to download 'input.txt'.

CONSTANTS = {
  # Puzzle 1
  # file: 'sample.txt', cheat_length: 2, threshold: 10, answer: 10, time: '53 ms',
  # file: 'input.txt', cheat_length: 2, threshold: 100, answer: 1332, time: '129 ms',
  # Puzzle 2
  # file: 'sample.txt', cheat_length: 20, threshold: 50, answer: 285, time: '62 ms',
  file: 'input.txt', cheat_length: 20, threshold: 100, answer: 987695, time: '2,912 ms',
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

race_times = map.collect { |row| Array.new(row.size, Float::INFINITY) }

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

x_range = 1...(map.size - 1)
y_range = 1...(map.first.size - 1)

savings = map.collect.with_index do |row, x|
  row.collect.with_index do |cell, y|
    next if cell == '#'

    current_race_time = race_times[x][y]

    x_spread = ((x - CONSTANTS[:cheat_length])..(x + CONSTANTS[:cheat_length]))
                 .select { |cheat_x| x_range.include?(cheat_x) }
    y_spread = ((y - CONSTANTS[:cheat_length])..(y + CONSTANTS[:cheat_length]))
                 .select { |cheat_y| y_range.include?(cheat_y) }

    x_spread
      .product(y_spread)
      .select { |cheat_x, cheat_y| ((x - cheat_x).abs + (y - cheat_y).abs) > 1 }
      .select { |cheat_x, cheat_y| ((x - cheat_x).abs + (y - cheat_y).abs) <= CONSTANTS[:cheat_length] }
      .map { |cheat_x, cheat_y| race_times[cheat_x][cheat_y] + (x - cheat_x).abs + (y - cheat_y).abs }
      .select { |cheat_race_time| current_race_time > cheat_race_time }
      .collect { |cheat_race_time| current_race_time - cheat_race_time }
  end
end.flatten.compact

puts "Savings (#{savings.size})"
puts '-------'
# puts savings
puts

answer = savings.count { |saving| saving >= CONSTANTS[:threshold] }

puts "Answer: #{answer}"
