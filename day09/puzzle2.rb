#!/usr/bin/env ruby

# Login to https://adventofcode.com/2024/day/9/input to download 'input.txt'.

# lines = readlines
# lines = File.readlines('sample.txt') # Answer: 2858 (in 56 ms)
lines = File.readlines('input.txt') # Answer: 6360363199987 (in 314,430 ms)

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

def find_file_before(blocks, pos)
  last_file_end = pos - 1
  last_file_end -= 1 while blocks[last_file_end].nil?
  last_file_start = blocks.find_index(blocks[last_file_end])

  last_file_start..last_file_end
end

def find_free_space(blocks, size)
  result = nil

  blocks.each_with_index { |_, i| result ||= i if (i + size - 1) < blocks.size && blocks[i..(i + size - 1)].all?(&:nil?) }

  result
end

pos = blocks.size
while pos.positive?
  file = find_file_before(blocks, pos)
  free_space_start = find_free_space(blocks, file.size)

  puts "file: #{file}: #{blocks[file]}"

  if free_space_start && free_space_start < file.first
    puts "  --> #{free_space_start..(free_space_start + file.size)}"

    file.each do |index|
      blocks[free_space_start + index - file.first], blocks[index] = blocks[index], blocks[free_space_start + index - file.first]
    end
  end

  # puts "| #{blocks.join(' | ')} |"
  # puts

  pos = file.first
end

checksum = 0
blocks.each_with_index do |block, i|
  checksum += (block || 0) * i
end

puts
puts "Checksum: #{checksum}"
