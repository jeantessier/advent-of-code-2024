#!/usr/bin/env ruby

require './numerical_keypad'
require './directional_keypad'

# Login to https://adventofcode.com/2024/day/21/input to download 'input.txt'.

CONSTANTS = {
  file: 'sample.txt', number_of_directional_keypads: 3, answer: Float::INFINITY, time: '?? ms',
  # file: 'input.txt', number_of_directional_keypads: 2, answer: Float::INFINITY, time: '?? ms',
}

lines = File.readlines(CONSTANTS[:file], chomp:true)

codes = lines

puts 'Codes'
puts '-----'
puts codes
puts

directional_keypad = DirectionalKeypad.new(nil)
(CONSTANTS[:number_of_directional_keypads] - 1).times do |_|
  directional_keypad = DirectionalKeypad.new(directional_keypad)
end
numerical_keypad = NumericalKeypad.new(directional_keypad)

Sequence = Data.define(:code, :shortest_sequence) do
  def complexity
    shortest_sequence * code.to_i
  end

  def to_s
    "#{code}: #{shortest_sequence} * #{code.to_i} = #{complexity}"
  end
end

sequences = codes.map do |code|
  Sequence.new(
    code,
    numerical_keypad
      .press_sequence(code)
      .map(&:size)
      .tap { |sizes| puts sizes.reduce(Hash.new(0)) { |histo, size| histo[size] += 1; histo } }
      .min,
  )
end

puts
puts 'Sequences'
puts '---------'
puts sequences
puts

answer = sequences.sum(&:complexity)

puts "Answer: #{answer}"
puts '--- too low ---' if answer < CONSTANTS[:answer]
puts '*** CORRECT ***' if answer == CONSTANTS[:answer]
puts '--- too high ---' if answer > CONSTANTS[:answer]
