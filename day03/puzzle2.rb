#!/usr/bin/env ruby

# Login to https://adventofcode.com/2024/day/3/input to download 'input.txt'.

# lines = readlines
# lines = File.readlines("sample2.txt") # Answer: 48 (in 49 ms)
lines = File.readlines("input.txt") # Answer: 84893551 (in 59 ms)

INSTRUCTION_REGEX = /((do\(\))|(don't\(\))|(mul\(\d{1,3},\d{1,3}\)))/
MUL_REGEX = /mul\((\d{1,3}),(\d{1,3})\)/
DO_REGEX = /do\(\)/
DONT_REGEX = /don't\(\)/

instructions = lines.map do |line|
  line.scan(INSTRUCTION_REGEX).map {|m| m[0]}
end

enabled = true
mul_instructions = instructions.flatten.find_all do |instruction|
  case instruction
  when DO_REGEX then enabled = true
  when DONT_REGEX then enabled = false
  end

  enabled && instruction =~ MUL_REGEX
end

multiplications = mul_instructions.map do |instruction|
  instruction.scan(MUL_REGEX).map do |n1, n2|
    n1.to_i * n2.to_i
  end
end

total = multiplications.flatten.sum

puts "total: #{total}"
