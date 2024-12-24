#!/usr/bin/env ruby

require './gate'

# Login to https://adventofcode.com/2024/day/24/input to download 'input.txt'.

CONSTANTS = {
  # file: 'sample1.txt', answer: 4, time: '58 ms',
  # file: 'sample2.txt', answer: 2024, time: '44 ms',
  file: 'input.txt', answer: 63168299811048, time: '65 ms',
}

lines = File.readlines(CONSTANTS[:file], chomp:true)

separator = lines.map.with_index { |line, i| line.empty? ? i : nil }.compact.first

WIRE_REGEX = /(?<wire>\w+): (?<value>[01])/

def bits_from(wires, prefix)
  wires
    .select { |wire, _| wire.start_with?(prefix) }
    .sort
    .reverse
end

def number_from(wires, prefix)
  bits_from(wires, prefix).reduce(0) do |acc, wire|
    acc | (wire[1] << (wire[0][1..].to_i))
  end
end

wires = lines[...separator]
          .map { |line| WIRE_REGEX.match(line) }
          .compact
          .reduce({}) do |hash, match|
            hash[match[:wire]] = match[:value].to_i
            hash
          end

puts 'Wires'
puts '-----'
puts wires
puts

GATE_REGEX = /(?<input1>\w+) (?<type>AND|OR|XOR) (?<input2>\w+) -> (?<output>\w+)/

gates = lines[(separator + 1)..]
  .map { |line| GATE_REGEX.match(line) }
  .compact
  .map do |match|
  case match[:type]
  when 'AND' then AndGate.new(match[:input1], match[:input2], match[:output])
  when 'OR' then OrGate.new(match[:input1], match[:input2], match[:output])
  when 'XOR' then XorGate.new(match[:input1], match[:input2], match[:output])
  else raise "Invalid gate type #{match[:type]}"
  end
end

puts 'Gates'
puts '-----'
puts gates
puts

puts 'Simulating'
puts '----------'

while gates.any?(&:indeterminate?)
  gates.select(&:indeterminate?).each { |gate| gate.check(wires) }
  puts "Indeterminate: #{gates.count(&:indeterminate?)} / #{gates.size}"
end

puts
puts 'Gates'
puts '-----'
puts gates
puts

puts 'Wires'
puts '-----'
puts wires
puts

z_wires = bits_from(wires, 'z')

puts 'Z Wires'
puts '-------'
puts z_wires.map { |_, v| v }.join
puts

answer = number_from(wires, 'z')

puts "Answer: #{answer}"
puts '__too low__' if answer < CONSTANTS[:answer]
puts '**CORRECT**' if answer == CONSTANTS[:answer]
puts '__too much__' if answer > CONSTANTS[:answer]
