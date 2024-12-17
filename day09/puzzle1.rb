#!/usr/bin/env ruby

# Login to https://adventofcode.com/2024/day/9/input to download 'input.txt'.

# lines = readlines
# lines = File.readlines('sample.txt', chomp: true) # Answer: 1928 (in 54 ms)
lines = File.readlines('input.txt', chomp: true) # Answer: 6344673854800 (in 772 ms)

disk_map = lines.first.chomp.split(//).map(&:to_i)

puts 'Disk Map'
puts '--------'
puts disk_map.inspect
puts

blocks = []
disk_map.each_slice(2).each_with_index do |pair, i|
  blocks += pair[0].times.map { i }
  blocks += pair[1].times.map { nil } if pair.size > 1
end

puts 'Blocks'
puts '------'
puts "| #{blocks.join(' | ')} |"
puts

first_free_index = blocks.find_index(nil)
last_file_index = blocks.size - 1

puts 'Indices'
puts '-------'
puts "free: #{first_free_index}, file: #{last_file_index}"
puts

while first_free_index < last_file_index
  blocks[first_free_index], blocks[last_file_index] = blocks[last_file_index], blocks[first_free_index]

  first_free_index += 1
  first_free_index += 1 until blocks[first_free_index].nil?

  last_file_index -= 1
  last_file_index -= 1 while blocks[last_file_index].nil?

  # puts "| #{blocks.join(' | ')} |"
end

checksum = 0
blocks.compact.each_with_index do |block, i|
  checksum += block * i
end

puts
puts "Checksum: #{checksum}"
