#!/usr/bin/env ruby

# Login to https://adventofcode.com/2024/day/11/input to download 'input.txt'.

# lines = readlines
# lines = File.readlines('sample.txt', chomp: true) # Answer: 65601038650482 (in 63 ms)
lines = File.readlines('input.txt', chomp: true) # Answer: 261936432123724 (in 381 ms)

class Stone
  attr_reader :number

  def initialize(number)
    @number = number
  end

  def blink
    case
    when number == '0' then [Stone.new('1')]
    when even_digits? then [Stone.new(left_part), Stone.new(right_part)]
    else [Stone.new((number.to_i * 2024).to_s)]
    end
  end

  def even_digits?
    number.length.even?
  end

  def left_part
    number[0...(number.length / 2)].sub(/^0+(\d+)/, '\1')
  end

  def right_part
    number[(number.length / 2)..].sub(/^0+(\d+)/, '\1')
  end

  def to_s
    number
  end
end

stones = lines.first.split.map { |number| Stone.new(number) }

puts 'Stones'
puts '------'
puts stones
puts

BLINK_CACHE = Hash.new { |hash, key| hash[key] = {} }
def blinks(stone, n)
  return 1 if n.zero?
  return BLINK_CACHE[stone.number][n] if BLINK_CACHE[stone.number][n]

  puts "blinks(#{stone.number}, #{n})"

  result = stone.blink.map { |s| blinks(s, n - 1) }.sum
  BLINK_CACHE[stone.number][n] = result

  result
end

total = stones.map { |stone| blinks(stone, 75) }.sum

puts
puts "Total: #{total}"
