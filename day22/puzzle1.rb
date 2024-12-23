#!/usr/bin/env ruby

# Login to https://adventofcode.com/2024/day/22/input to download 'input.txt'.

# lines = readlines
# lines = File.readlines('sample1.txt', chomp: true) # Answer: 37327623 (in 56 ms)
lines = File.readlines('input.txt', chomp: true) # Answer: 17612566393 (in 792 ms)

initial_numbers = lines.map(&:to_i)

puts 'Initial Numbers'
puts '---------------'
puts initial_numbers
puts

def next_secret_number(secret_number)
  secret_number = mix_and_prune(secret_number, secret_number << 6) # Multiply by 64, or shift left by 6 bits
  secret_number = mix_and_prune(secret_number, secret_number >> 5) # Divide by 32, or shift right by 5 bits
  secret_number = mix_and_prune(secret_number, secret_number << 11) # Multiply by 248, or shift left by 11 bits
end

def mix_and_prune(n, mixin)
  # mix: XOR together
  # prune: modulo 16777216 (keep the lowest 24 bits, or AND with 16777215 (all 1's))
  (n ^ mixin) & 16777215
end

next_2000_secret_numbers = initial_numbers.map do |secret_number|
  2000.times.reduce(secret_number) { |acc, _| next_secret_number(acc) }
end

puts '2000th Numbers'
puts '--------------'
puts next_2000_secret_numbers
puts

answer = next_2000_secret_numbers.sum

puts "Answer: #{answer}"
