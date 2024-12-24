#!/usr/bin/env ruby

require './gate'

# Login to https://adventofcode.com/2024/day/24/input to download 'input.txt'.

CONSTANTS = {
  # file: 'sample3.txt', number_of_pairs: 2, answer: 'z00,z01,z02,z05', time: '?? ms',
  file: 'input.txt', number_of_pairs: 4, answer: '??', time: '?? ms',
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

puts "Wires (#{wires.size})"
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

puts "Gates (#{gates.size})"
puts '-----'
puts gates
puts

x = number_from(wires, 'x')
y = number_from(wires, 'y')
expected_z = x + y

puts 'Numbers'
puts '-------'
puts "    x: #{x}"
puts "    y: #{y}"
puts "x + y: #{expected_z}"
puts

def simulate(wires, gates)
  while gates.any?(&:indeterminate?)
    old_count = gates.count(&:indeterminate?)

    gates.select(&:indeterminate?).each { |gate| gate.check(wires) }

    break if gates.count(&:indeterminate?) == old_count
  end
end

def swap_and_simulate(wires, gates, pairs = [])
  cloned_wires = wires.clone
  cloned_gates = gates.collect(&:clone)

  pairs.each do |pair|
    cloned_gates[pair[0]].output, cloned_gates[pair[1]].output = cloned_gates[pair[1]].output, cloned_gates[pair[0]].output
  end

  simulate(cloned_wires, cloned_gates)

  number_from(cloned_wires, 'z')
end

initial_z = swap_and_simulate(wires, gates)

outputs = gates.collect { |gate| [gate.output, gate] }.to_h

def dfs(gates, wire)
  gate = gates.find { |gate| gate.output == wire }

  return [] unless gate

  [gate] + dfs(gates, gate.input1) + dfs(gates, gate.input2)
end

tree_to_z = gates
              .map(&:output)
              .select { |wire| wire.start_with?('z') }
              .collect { |wire| dfs(gates, wire) }
              .flatten
              .uniq

puts "Tree to Z (#{tree_to_z.size})"
puts '---------'
puts tree_to_z
puts

# candidates = []
#
# (0...gates.size).each do |p1a|
#   ((p1a + 1)...gates.size).each do |p1b|
#
#     # puts "Swaping out #{p1a} and #{p1b}"
#     candidate = [p1a, p1b]
#     new_z = swap_and_simulate(wires, gates, [candidate])
#     candidates << candidate if new_z != initial_z
#   end
# end
#
# puts
# puts "Candidates (#{candidates.size})"
# puts '----------'
# # candidates.each { |c| puts c.inspect }
# puts

# answer = number_from(wires, 'z')
#
# puts
# puts 'Numbers'
# puts '-------'
# puts "    x: #{number_from(wires, 'x')}"
# puts "    y: #{number_from(wires, 'y')}"
# puts "x + y: #{expected_z_wire}"
# puts "    z: #{answer}"
# puts (answer == expected_z_wire) ? '**CORRECT**' : '__wrong__'
