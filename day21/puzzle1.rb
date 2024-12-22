#!/usr/bin/env ruby

require './numerical_keypad'
require './directional_keypad'

# Login to https://adventofcode.com/2024/day/21/input to download 'input.txt'.

CONSTANTS = {
  # file: 'sample.txt', answer: 126384, time: '65 ms',
  file: 'input.txt', answer: 197560, time: '132 ms',
}

lines = File.readlines(CONSTANTS[:file], chomp:true)

codes = lines

puts 'Codes'
puts '-----'
puts codes
puts

depressurized_keypad = NumericalKeypad.new nil
radiation_keypad = DirectionalKeypad.new nil
cold_keypad = DirectionalKeypad.new nil

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
    depressurized_keypad
      .press_sequence(code)
      .collect { |s| radiation_keypad.press_sequence s }
      .flatten
      .collect { |s| cold_keypad.press_sequence s }
      .flatten
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
