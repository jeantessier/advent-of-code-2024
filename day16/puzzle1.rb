#!/usr/bin/env ruby

# Login to https://adventofcode.com/2024/day/16/input to download 'input.txt'.

# lines = readlines
# lines = File.readlines('sample1.txt') # Answer: 7036 (in 73 ms) **77 cycles** **285 paths**
# lines = File.readlines('sample2.txt') # Answer: 11048 (in 74 ms) **98 cycles** **122 paths**
lines = File.readlines('input.txt') # Answer: ?? (in ?? ms)

Coord = Data.define(:x, :y) do
  def +(other)
    Coord.new(x + other.x, y + other.y)
  end

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

map = lines.map(&:chomp).map { |line| line.split('') }

puts 'Map'
puts '---'
print_map(map)
puts

class Path
  def initialize(map:, coords:, facing:, steps: [])
    @map = map
    @coords = coords
    @facing = facing
    @steps = steps
    @active = true
  end

  def coord
    @coords.last
  end

  def active?
    @active
  end

  def complete?
    @map[coord.x][coord.y] == 'E'
  end

  def score
    histo = @steps.reduce(Hash.new(0)) do |acc, step|
      acc[step] += 1
      acc
    end

    (histo['r'] + histo['l']) * 1_000 + histo['f']
  end

  def look_forward
    next_pos = case @facing
               when 'N' then coord + Coord.new(-1, 0)
               when 'E' then coord + Coord.new(0, 1)
               when 'S' then coord + Coord.new(1, 0)
               when 'W' then coord + Coord.new(0, -1)
               end

    @map[next_pos.x][next_pos.y]
  end

  def look_right
    next_pos = case @facing
               when 'N' then coord + Coord.new(0, 1)
               when 'E' then coord + Coord.new(1, 0)
               when 'S' then coord + Coord.new(0, -1)
               when 'W' then coord + Coord.new(-1, 0)
               end

    @map[next_pos.x][next_pos.y]
  end

  def look_left
    next_pos = case @facing
               when 'N' then coord + Coord.new(0, -1)
               when 'E' then coord + Coord.new(-1, 0)
               when 'S' then coord + Coord.new(0, 1)
               when 'W' then coord + Coord.new(1, 0)
               end

    @map[next_pos.x][next_pos.y]
  end

  def move_forward
    next_pos = case @facing
               when 'N' then coord + Coord.new(-1, 0)
               when 'E' then coord + Coord.new(0, 1)
               when 'S' then coord + Coord.new(1, 0)
               when 'W' then coord + Coord.new(0, -1)
               end

    if @coords.include?(next_pos)
      @active = false
    else
      @steps << 'f'
      @coords << next_pos
    end

    self
  end

  def turn_right
    @steps << 'r'
    @facing = case @facing
              when 'N' then 'E'
              when 'E' then 'S'
              when 'S' then 'W'
              when 'W' then 'N'
              end
    self
  end

  def turn_left
    @steps << 'l'
    @facing = case @facing
              when 'N' then 'W'
              when 'E' then 'N'
              when 'S' then 'E'
              when 'W' then 'S'
              end
    self
  end

  def next_move
    # puts "next_move from #{coord} facing #{@facing}"
    new_paths = []

    right = look_right
    forward = look_forward
    left = look_left

    # puts "  right: #{right}, forward: #{forward}, left: #{left}"

    case
    when right != '#' && forward != '#' && left != '#'
      new_paths << clone.turn_right.move_forward
      new_paths << clone.turn_left.move_forward
      move_forward
    when right == '#' && forward != '#' && left != '#'
      new_paths << clone.turn_left.move_forward
      move_forward
    when right != '#' && forward == '#' && left != '#'
      new_paths << clone.turn_right.move_forward
      turn_left
    when right != '#' && forward != '#' && left == '#'
      new_paths << clone.turn_right.move_forward
      move_forward
    when right != '#' && forward == '#' && left == '#'
      turn_right.move_forward
    when right == '#' && forward != '#' && left == '#'
      move_forward
    when right == '#' && forward == '#' && left != '#'
      turn_left.move_forward
    when right == '#' && forward == '#' && left == '#'
      @active = false
    end

    if complete?
      @active = false
    end

    # puts "  new_paths: #{new_paths.map(&:to_s).join(', ')}"

    new_paths
  end

  def clone
    Path.new(map: @map, coords: @coords.clone, facing: @facing, steps: @steps.clone)
  end

  def to_s
    [
      coord,
      @facing,
      @steps.join,
      score,
      active? ? '**active**' : '_inactive_',
      complete? ? 'COMPLETED' : '',
    ].join(' ')
  end
end

paths = map.collect.with_index do |row, x|
  row.collect.with_index do |cell, y|
    cell == 'S' ? Path.new(map: map, coords: [Coord.new(x, y)], facing: 'E') : nil
  end
end.flatten.compact

puts 'Paths'
puts '-----'
puts paths
puts

n = 0
while paths.any?(&:active?)
  paths += paths.select(&:active?).collect { |path| path.next_move }.flatten.filter(&:active?)

  n += 1
  puts "#{n} -- Paths: #{paths.count(&:active?)} / #{paths.size}"

  # puts
  # puts 'Paths'
  # puts '-----'
  # puts paths
  # puts
  #
  # puts "[enter] to continue"
  # $stdin.gets
end

possible_scores = paths.select(&:complete?).map(&:score)

puts 'Possible Scores'
puts '---------------'
puts possible_scores.inspect
puts

lowest_score = possible_scores.min

puts
puts "Lowest Score: #{lowest_score}"
