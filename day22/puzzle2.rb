#!/usr/bin/env ruby

# Login to https://adventofcode.com/2024/day/22/input to download 'input.txt'.

# lines = readlines
# lines = File.readlines('sample2.txt', chomp: true) # Answer: 23 (in 73 ms)
lines = File.readlines('input.txt', chomp: true) # Answer: 1968 (in 21,706 ms)

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

def price(secret_number)
  secret_number % 10
end

sequences = initial_numbers.map do |n|
  first_frame = { secret_number: n, price: price(n), delta: nil }

  2000.times.reduce([first_frame]) do |acc, _|
    previous = acc.last

    secret_number = next_secret_number(previous[:secret_number])
    price = price(secret_number)

    acc << {
      secret_number:,
      price:,
      delta: price - previous[:price],
    }
  end
end

puts 'Sequences'
puts '---------'
sequences.each do |sequence|
  puts sequence.take(10)
  puts '...'
  puts
end

pattern_sets = sequences.map do |sequence|
  pattern = []

  sequence.reduce(Hash.new(0)) do |hash, frame|
    pattern << frame[:delta] unless frame[:delta].nil?
    pattern.shift if pattern.size > 4

    if pattern.size == 4
      key = pattern.join(',')
      hash[key] = frame[:price] unless hash.key?(key)
    end

    hash
  end
end

puts 'Pattern Sets'
puts '------------'
pattern_sets.each do |patterns|
  patterns.take(10).each do |pattern, price|
    puts "#{pattern}: #{price}"
  end
  puts '...'
  puts
end

patterns = pattern_sets.map(&:keys).flatten.uniq

puts 'Patterns'
puts '--------'
puts patterns.take(10)
puts '...'
puts

patterns_and_prices = patterns.reduce({}) do |hash, pattern|
  hash[pattern] = pattern_sets.map { |set| set[pattern] }
  hash
end

puts 'Patterns w/ Prices'
puts '------------------'
puts patterns_and_prices.take(10).to_h
puts '...'
puts

answer = patterns_and_prices.map { |_, prices| prices.sum }.max

puts "Answer: #{answer}"
