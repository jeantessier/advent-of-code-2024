#!/usr/bin/env ruby

# Login to https://adventofcode.com/2024/day/15/input to download 'input.txt'.

# lines = readlines
# lines = File.readlines('sample1.txt', chomp: true) # Answer: 2028 (in 56 ms)
# lines = File.readlines('sample2.txt', chomp: true) # Answer: 10092 (in 66 ms)
lines = File.readlines('input.txt', chomp: true) # Answer: 1495147 (in 134 ms)

Coord = Data.define(:x, :y) do
  def gps
    (100 * x) + y
  end

  def +(other)
    Coord.new(x + other.x, y + other.y)
  end
  
  def to_s
    "(#{x}, #{y})"
  end
end

Move = Data.define(:x, :y) do
  def to_s
    "(#{x.positive? ? '+' : ''}#{x}, #{y.positive? ? '+' : ''}#{y})"
  end
end

# Renders the map (on *STDOUT* by default)
def print_map(map, out = $stdout)
  map.each do |row|
    out.puts row.join
  end
end

separators = lines.map.with_index { |line, i| line.empty? ? i : nil }.compact

map = lines[...(separators.first)].map do |line|
  line.split('')
end

puts 'Map'
puts '---'
print_map(map)
puts

robot = map.collect.with_index do |row, x|
  row.collect.with_index do |cell, y|
    (cell == '@') ? Coord.new(x, y) : nil
  end
end.flatten.compact.first

puts 'Robot'
puts '-----'
puts robot
puts

movements = lines[(separators.first)..].join.split('').map do |move|
  case move
  when '^' then Move.new(-1, 0)
  when '>' then Move.new(0, 1)
  when 'v' then Move.new(1, 0)
  when '<' then Move.new(0, -1)
  else raise "Illegal movement: #{move}"
  end
end

# puts 'Movements'
# puts '---------'
# puts movements
# puts

def swap(map, position, new_position)
  map[position.x][position.y], map[new_position.x][new_position.y] = map[new_position.x][new_position.y], map[position.x][position.y]
end

def one_movement(map, position, move)
  new_position = position + move

  case map[new_position.x][new_position.y]
  when '#'
    puts 'No nothing'
    return position
  when '.'
    puts 'Move to empty space'
    swap(map, position, new_position)
    return new_position
  when 'O'
    puts 'Attempt to move box'
    one_movement(map, new_position, move)
    if map[new_position.x][new_position.y] == '.'
      puts 'Move to now empty space'
      swap(map, position, new_position)
      return new_position
    else
      return position
    end
  else
    raise "Illegal movement to #{new_position}: #{map[new_position.x][new_position.y]}"
  end
end

movements.each do |move|
  puts "Move: #{move}"
  robot = one_movement(map, robot, move)
  # print_map(map)
  # puts
end

def get_box_coords(map)
  map.collect.with_index do |row, x|
    row.collect.with_index do |cell, y|
      (cell == 'O') ? Coord.new(x, y) : nil
    end
  end.flatten.compact
end

coordinates = get_box_coords(map)

# puts 'Coordinates'
# puts '-----------'
# puts coordinates
# puts

total = coordinates.sum(&:gps)

puts
puts "Total: #{total}"
