#!/usr/bin/env ruby

# Login to https://adventofcode.com/2024/day/8/input to download 'input.txt'.

# lines = readlines
# lines = File.readlines('sample.txt') # Answer: 14 (in 58 ms)
lines = File.readlines('input.txt') # Answer: 261 (in 62 ms)

Coord = Struct.new(:x, :y) do
  def to_s
    "(#{x}, #{y})"
  end
end

# Renders the map (on *STDOUT* by default)
def print_map(map, out = $stdout)
  map.each do |row|
    out.puts row.join
  end
end

map = lines.map do |line|
  line.chomp.split('')
end

puts 'Map'
puts '---'
print_map(map)
puts

x_range = 0...map.size
y_range = 0...map.first.size

puts 'Ranges'
puts '------'
puts "x_range: #{x_range}"
puts "y_range: #{y_range}"
puts

frequencies = Hash.new { |h, k| h[k] = [] }

x_range.each do |x|
  y_range.each do |y|
    if /[A-Za-z0-9]/.match?(map[x][y])
      frequencies[map[x][y]] << Coord.new(x, y)
    end
  end
end

puts 'Frequencies'
puts '-----------'
frequencies.keys.sort.each do |frequency|
  puts "#{frequency}: #{frequencies[frequency].join(', ')}"
end
puts

# def combinations(antennas)
#   return [] if antennas.size < 2
#   return antennas if antennas.size == 2
#
#   combinations(antennas[1..]).map do |combination|
#     combination.unshift(antennas.first)
#   end
# end

total = frequencies.map do |frequency, antennas|
  puts "#{frequency}: #{antennas.join(', ')}"
  antennas
    .product(antennas)
    .reject { |pair| pair.first == pair.last }
    .map do |pair|
      puts "  pair #{pair.join(', ')}"
      bounding_box = [
        Coord.new([pair.first.x, pair.last.x].min, [pair.first.y, pair.last.y].min),
        Coord.new([pair.first.x, pair.last.x].max, [pair.first.y, pair.last.y].max),
      ]
      dx = bounding_box.last.x - bounding_box.first.x
      dy = bounding_box.last.y - bounding_box.first.y
      possible_antinodes = [
        Coord.new(bounding_box.first.x - dx, bounding_box.first.y - dy), # NW corner
        Coord.new(bounding_box.first.x - dx, bounding_box.last.y + dy), # NE corner
        Coord.new(bounding_box.last.x + dx, bounding_box.last.y + dy), # SE corner
        Coord.new(bounding_box.last.x + dx, bounding_box.first.y - dy), # SW corner
      ]
      if pair.include?(bounding_box.first)
        puts "    antinodes: #{possible_antinodes[(0..).step(2)].join(', ')}"
        possible_antinodes[(0..).step(2)]
      else
        puts "    antinodes: #{possible_antinodes[(1..).step(2)].join(', ')}"
        possible_antinodes[(1..).step(2)]
      end
    end
end
.flatten
.uniq
.filter { |antinode| x_range.include?(antinode.x) && y_range.include?(antinode.y) }
.size

puts
puts "Total: #{total}"
