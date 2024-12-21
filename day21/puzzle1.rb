#!/usr/bin/env ruby

# Login to https://adventofcode.com/2024/day/21/input to download 'input.txt'.

CONSTANTS = {
  file: 'sample.txt', answer: 126384, time: '?? ms',
  # file: 'input.txt', answer: 195516, time: '?? ms', # **too low**
}

lines = File.readlines(CONSTANTS[:file], chomp:true)

codes = lines

puts 'Codes'
puts '-----'
puts codes
puts

Coord = Data.define(:x, :y) do
  def to_s
    "(#{x}, #{y})"
  end
end

NUMERICAL_KEYPAD = {
  '7' => Coord.new(0, 0), '8' => Coord.new(0, 1), '9' => Coord.new(0, 2),
  '4' => Coord.new(1, 0), '5' => Coord.new(1, 1), '6' => Coord.new(1, 2),
  '1' => Coord.new(2, 0), '2' => Coord.new(2, 1), '3' => Coord.new(2, 2),
                          '0' => Coord.new(3, 1), 'A' => Coord.new(3, 2),
}

DIRECTIONAL_KEYPAD = {
                          '^' => Coord.new(0, 1), 'A' => Coord.new(0, 2),
  '<' => Coord.new(1, 0), 'v' => Coord.new(1, 1), '>' => Coord.new(1, 2),
}

Vector = Data.define(:start_pos, :end_pos) do
  def movements
    x_movements + y_movements + 'A'
  end

  def x_movements
    delta = end_pos.x - start_pos.x
    distance = delta.abs
    direction = delta == distance ? 'v' : '^'

    distance.times.collect { |_| direction }.join
  end

  def y_movements
    delta = end_pos.y - start_pos.y
    distance = delta.abs
    direction = delta == distance ? '>' : '<'

    distance.times.collect { |_| direction }.join
  end

  def to_s
    "#{start_pos} --> #{end_pos}"
  end
end

KeypadSequence = Struct.new(:code) do
  def shortest_sequence
    @shortest_sequence ||=
      guide_directional_keypad(    # you
        guide_directional_keypad(  # -40 degrees robot
          guide_numerical_keypad(  # high-level radiation robot
            code                   # depressurized robot
          )
        )
      )
  end

  def complexity
    shortest_sequence.size * code.to_i
  end

  def to_s
    "#{code}: #{shortest_sequence} (#{shortest_sequence.size}) --> #{shortest_sequence.size} * #{code.to_i} = #{complexity}"
  end

  def guide_numerical_keypad(sequence) = guide_keypad NUMERICAL_KEYPAD, sequence
  def guide_directional_keypad(sequence) = guide_keypad DIRECTIONAL_KEYPAD, sequence

  def guide_keypad(keypad, sequence)
    ('A' + sequence)
      .split('')
      .each_cons(2)
      .map { |pair| pair.map { |key| keypad[key] } }
      # .tap { |e| puts e.inspect }
      .map { |start_coord, end_coord| Vector.new(start_coord, end_coord) }
      .map(&:movements)
      .join
  end
end

sequences = codes.map { |code| KeypadSequence.new(code) }

puts 'Sequences'
puts '---------'
sequences.each do |sequence|
  puts '============================================================='
  puts sequence.shortest_sequence
  puts sequence.guide_directional_keypad(sequence.guide_numerical_keypad(sequence.code))
  puts sequence.guide_numerical_keypad(sequence.code)
  puts sequence.code
  puts '-------------------------------------------------------------'
  puts sequence
  puts '============================================================='
  puts
end
puts

answer = sequences.sum(&:complexity)

puts "Answer: #{answer}"
puts '--- too low ---' if answer < CONSTANTS[:answer]
puts '*** CORRECT ***' if answer == CONSTANTS[:answer]
puts '--- too high ---' if answer > CONSTANTS[:answer]
