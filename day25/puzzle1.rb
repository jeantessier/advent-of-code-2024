#!/usr/bin/env ruby

# Login to https://adventofcode.com/2024/day/25/input to download 'input.txt'.

# lines = readlines
# lines = File.readlines('sample.txt', chomp: true) # Answer: 3 (in 61 ms)
lines = File.readlines('input.txt', chomp: true) # Answer: 2950 (in 103 ms)

separators = lines.map.with_index { |line, i| line.empty? ? i : nil }.compact

schematic_ranges = ([-1] + separators + [lines.size]).each_cons(2).map { |pair| (pair.first + 1)...(pair.last) }

locks = schematic_ranges
          .map { |range| lines[range] }
          .select { |schematic| schematic[0].match(/^#+$/) && schematic[-1].match(/^\.+$/) }
          .map do |schematic|
            schematic[1...-1].map { |row| row.split('').map {|cell| cell == '#' ? 1 : 0 } }
          end
          .map do |positions|
            (0...(positions.first.size)).collect { |col| positions.collect { |row| row[col] }.sum }
          end

puts "Locks (#{locks.size})"
puts '-----'
locks.each { |lock| puts lock.inspect }
puts

keys = schematic_ranges
          .map { |range| lines[range] }
          .select { |schematic| schematic[0].match(/^\.+$/) && schematic[-1].match(/^#+$/) }
          .map do |schematic|
            schematic[1...-1].map { |row| row.split('').map {|cell| cell == '#' ? 1 : 0 } }
          end
          .map do |positions|
            (0...(positions.first.size)).collect { |col| positions.collect { |row| row[col] }.sum }
          end

puts "Keys (#{keys.size})"
puts '----'
keys.each { |key| puts key.inspect }
puts

answer = locks.product(keys).count do |lock, key|
  lock.zip(key).map { |pair| pair.sum }.all? { |sum| sum <= 5 }
end

puts "Answer: #{answer}"
