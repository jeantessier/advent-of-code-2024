#!/usr/bin/env ruby

# Login to https://adventofcode.com/2024/day/9/input to download 'input.txt'.

# lines = readlines
# lines = File.readlines('sample.txt', chomp: true) # Answer: 2858 (in 58 ms)
lines = File.readlines('input.txt', chomp: true) # Answer: 6360363199987 (in 5,572 ms)

disk_map = lines.first.chomp.split(//).map(&:to_i)

puts 'Disk Map'
puts '--------'
puts disk_map.inspect
puts

class FileBlocks
  attr_reader :id, :size

  def initialize(id, size)
    @id = id
    @size = size
  end

  def to_s
    "#{id}[#{size}]"
  end
end

class FreeBlocks
  attr_reader :size

  def initialize(size)
    @size = size
  end

  def decrease_by!(n)
    @size -= n
  end

  def to_s
    "(#{size})"
  end
end

sequences = []
disk_map.each_slice(2).each_with_index do |pair, i|
  sequences << FileBlocks.new(i, pair[0])
  sequences << FreeBlocks.new(pair[1]) if pair.size > 1 && pair[1].positive?
end

puts 'Sequences'
puts '---------'
puts "| #{sequences.join(' | ')} |"
puts

sequences.select { |blocks| blocks.is_a? FileBlocks }.reverse.each do |file_blocks|
  file_pos = sequences.find_index(file_blocks)
  free_space_pos = sequences.find_index { |blocks| blocks.is_a?(FreeBlocks) && blocks.size >= file_blocks.size }

  if free_space_pos && free_space_pos < file_pos
    file = sequences.delete_at(file_pos)
    puts "  #{file}: #{file_pos} --> #{free_space_pos}"
    free = sequences[free_space_pos]
    sequences.insert(free_space_pos, file)
    free.decrease_by!(file.size)
    sequences.insert(file_pos + 1, FreeBlocks.new(file.size))
  end

  # puts "| #{sequences.join(' | ')} |"
end

# puts
# puts 'Sequences'
# puts '---------'
# puts "| #{sequences.join(' | ')} |"
# puts

pos = 0
checksum = sequences.map do |blocks|
  pos += blocks.size
  case blocks
  when FreeBlocks
    0
  when FileBlocks
    ((pos - blocks.size)...pos).map { |i| blocks.id * i }.sum
  else
    throw Exception.new 'Unexpected block'
  end
end.sum

puts
puts "Checksum: #{checksum}"
