#!/usr/bin/env ruby

require './gate'

# Login to https://adventofcode.com/2024/day/24/input to download 'input.txt'.

# lines = readlines
# lines = File.readlines('sample1.txt', chomp: true) # Answer: 4 (in 58 ms)
# lines = File.readlines('sample2.txt', chomp: true) # Answer: 2024 (in 44 ms)
lines = File.readlines('input.txt', chomp: true) # Answer: 63168299811048 (in 65 ms)

separator = lines.map.with_index { |line, i| line.empty? ? i : nil }.compact.first

WIRE_REGEX = /(?<wire>\w+): (?<value>[01])/

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

z_wires = wires
            .select { |wire, _| wire.start_with?('z') }
            .sort
            .reverse

puts 'Z Wires'
puts '-------'
puts z_wires.map { |_, v| v }.join
puts

answer = z_wires.reduce(0) do |acc, wire|
  acc | (wire[1] << (wire[0][1..].to_i))
end

puts "Answer: #{answer}"
