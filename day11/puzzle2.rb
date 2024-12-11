#!/usr/bin/env ruby

# Login to https://adventofcode.com/2024/day/11/input to download 'input.txt'.

# lines = readlines
lines = File.readlines('sample.txt') # Answer: ?? (in ?? ms)
# lines = File.readlines('input.txt') # Answer: ?? (in ?? ms)

class Stone
  attr_reader :number

  def initialize(number)
    @number = number
  end

  def blink
    case
    when number == 0 then [Stone.new(1)]
    when even_digits? then [Stone.new(left_part), Stone.new(right_part)]
    else [Stone.new(number * 2024)]
    end
  end

  def string_number
    @string_number ||= number.to_s
  end

  def even_digits?
    string_number.length.even?
  end

  def left_part
    string_number[0...(string_number.length / 2)].to_i
  end

  def right_part
    string_number[(string_number.length / 2)..].to_i
  end
  
  def to_s
    string_number
  end
end

stones = lines.first.split.map(&:to_i).map { |number| Stone.new(number) }

puts 'Stones'
puts '------'
puts stones
puts

75.times do |n|
  puts "Blink! (#{n + 1})"
  # puts

  stones = stones.map(&:blink).flatten

  # puts 'Stones'
  # puts '------'
  # puts stones
  # puts
end

puts
puts "Number of stones: #{stones.size}"
