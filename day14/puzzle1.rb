#!/usr/bin/env ruby

# Login to https://adventofcode.com/2024/day/14/input to download 'input.txt'.

CONSTANTS = {
  # file: 'sample.txt', x_size: 11, y_size: 7, answer: 12, time: '59 ms',
  file: 'input.txt', x_size: 101, y_size: 103, answer: 226_548_000, time: '96 ms',
}

lines = File.readlines(CONSTANTS[:file])

Robot = Data.define(:x, :y, :velocity_x, :velocity_y) do
  def coord
    [x, y]
  end

  def move(n = 1)
    Robot.new(
      (x + (n * velocity_x)) % CONSTANTS[:x_size],
      (y + (n * velocity_y)) % CONSTANTS[:y_size],
      velocity_x,
      velocity_y,
    )
  end

  def to_s
    "(#{x}, #{y})"
  end
end

ROBOT_REGEX = /p=(?<start_x>\d+),(?<start_y>\d+) v=(?<velocity_x>-?\d+),(?<velocity_y>-?\d+)/

robots = lines.map { |line| ROBOT_REGEX.match(line) }.compact.map do |match|
  Robot.new match[:start_x].to_i, match[:start_y].to_i, match[:velocity_x].to_i, match[:velocity_y].to_i
end

def print_map(robots)
  grid = robots.map(&:coord).reduce(Hash.new { |h, k| h[k] = [] }) do |map, coord|
    map[coord] << coord
    map
  end

  (0...CONSTANTS[:y_size]).each do |y|
    puts (0...CONSTANTS[:x_size]).map { |x| grid[[x, y]].empty? ? '.' : grid[[x, y]].size }.join('')
  end
end

puts 'Robots'
puts '------'
print_map(robots)
puts robots
puts

moved_robots = robots.map { |robot| robot.move(100) }

puts 'Moved Robots'
puts '------------'
print_map(moved_robots)
puts robots
puts

def quadrant(robots, x_range, y_range)
  robots.select { |robot| x_range.include?(robot.x) && y_range.include?(robot.y) }
end

quadrants = [
  [0...(CONSTANTS[:x_size] / 2), 0...(CONSTANTS[:y_size] / 2)],
  [0...(CONSTANTS[:x_size] / 2), ((CONSTANTS[:y_size] / 2) + 1)..],
  [((CONSTANTS[:x_size] / 2) + 1).., 0...(CONSTANTS[:y_size] / 2)],
  [((CONSTANTS[:x_size] / 2) + 1).., ((CONSTANTS[:y_size] / 2) + 1)..],
].map { |ranges| quadrant(moved_robots, ranges[0], ranges[1]) }

puts 'Quadrants'
puts '---------'
quadrants.each do |robots_in_quadrant|
  print_map robots_in_quadrant
  puts
end

safety_factor = quadrants.map(&:size).reduce(:*)

puts "Safety Factor: #{safety_factor}"
