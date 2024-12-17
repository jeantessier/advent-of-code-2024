#!/usr/bin/env ruby

# Login to https://adventofcode.com/2024/day/15/input to download 'input.txt'.

# lines = readlines
# lines = File.readlines('sample2.txt', chomp: true) # Answer: 9021 (in 76 ms)
# lines = File.readlines('sample3.txt', chomp: true) # Answer: 618 (in 50 ms)
lines = File.readlines('input.txt', chomp: true) # Answer: 1524905 (in 160 ms)

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
  def horizontal?
    x.zero?
  end

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
  line.split('').map do |char|
    case char
    when '#' then ['#', '#']
    when 'O' then ['[', ']']
    when '.' then ['.', '.']
    when '@' then ['@', '.']
    end
  end.flatten
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

def swap_single(map, position, new_position)
  map[position.x][position.y], map[new_position.x][new_position.y] = map[new_position.x][new_position.y], map[position.x][position.y]
end

def swap_many(map, positions, new_positions)
  positions.zip(new_positions).each do |position, new_position|
    swap_single(map, position, new_position)
  end
end

def obstructed?(map, positions)
  positions.any? { |position| map[position.x][position.y] == '#' }
end

def all_clear?(map, positions)
  positions.all? { |position| map[position.x][position.y] == '.' }
end

def can_move?(map, positions, move)
  new_positions = positions.map { |position| position + move }

  return false if obstructed?(map, new_positions)
  return true if all_clear?(map, new_positions)

  new_positions.all? do |new_position|
    case map[new_position.x][new_position.y]
    when '[' then can_move?(map, [new_position, Coord.new(new_position.x, new_position.y + 1)], move)
    when ']' then can_move?(map, [Coord.new(new_position.x, new_position.y - 1), new_position], move)
    when '.' then true
    else raise "Unknown thing at map #{new_position}: #{map[new_position.x][new_position.y]}"
    end
  end
end

def one_movement(map, positions, move)
  new_positions = positions.map { |position| position + move }

  if obstructed?(map, new_positions)
    puts 'No nothing'
    return positions
  end

  if all_clear?(map, new_positions)
    puts 'Move to empty space'
    swap_many(map, positions, new_positions)
    return new_positions
  end

  if move.horizontal?
    puts 'Attempt to move box horizontally'
    one_movement(map, new_positions, move)
    if all_clear?(map, new_positions)
      puts 'Move to now empty space'
      swap_many(map, positions, new_positions)
      return new_positions
    else
      return positions
    end
  else
    puts 'Attempt to move box(es) vertically'

    box_positions = new_positions.collect do |new_position|
      case map[new_position.x][new_position.y]
      when '[' then [new_position, Coord.new(new_position.x, new_position.y + 1)]
      when ']' then [Coord.new(new_position.x, new_position.y - 1), new_position]
      when '.' then []
      else raise "Unknown thing at map #{new_position}: #{map[new_position.x][new_position.y]}"
      end
    end.flatten.uniq

    if can_move?(map, box_positions, move)
      one_movement(map, box_positions, move)
      swap_many(map, positions, new_positions)
      return new_positions
    else
      puts 'Cannot move boxes'
      return positions
    end
  end
end

movements.each do |move|
  puts "Move: #{move}"
  robot = one_movement(map, [robot], move).first
  # print_map(map)
  # puts
end

def get_box_coords(map)
  map.collect.with_index do |row, x|
    row.collect.with_index do |cell, y|
      (cell == '[') ? Coord.new(x, y) : nil
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
