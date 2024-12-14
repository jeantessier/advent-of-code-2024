#!/usr/bin/env ruby

# Login to https://adventofcode.com/2024/day/14/input to download 'input.txt'.

CONSTANTS = {
  file: 'input.txt', x_size: 101, y_size: 103, answer: 7753, time: '1,172 ms',
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

# Looks for a row of 13+ robots with 13+ of them side-by-side,
# as potentially part of a picture.  Using 13 and 10 yielded
# 26 candidates.  13 and 13 yields 4 candidates.
def analyze(robots)
  robots
    .group_by { |robot| robot.y }
    .select { |_, v| v.size >= 13 }
    .any? do |_, robots|
      robots
        .map(&:x)
        .sort
        .each_cons(2)
        .collect { |x1, x2| (x2 - x1).abs }
        .count(1) >= 13
    end
end

# By submitting various numbers to the AoC website, I was
# able to narrow it down to between 5,000 and 10,000.
candidates = (5_000..10_000).select do |seconds|
  analyze(robots.map { |robot| robot.move(seconds) })
end

puts 'Candidates'
puts '----------'
candidates.each do |candidate|
  puts "candidate #{candidate}"
  print_map(robots.map { |robot| robot.move(candidate) })
  puts
end
puts

puts "Number of Candidates: #{candidates.size}"
