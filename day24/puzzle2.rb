#!/usr/bin/env ruby

require './gate'

# Login to https://adventofcode.com/2024/day/24/input to download 'input.txt'.

CONSTANTS = {
  # file: 'sample3.txt', answer: 'z00,z01,z02,z05', time: '?? ms',
  file: 'input.txt', answer: 'dwp,ffj,gjh,jdr,kfm,z08,z22,z31', time: '?? ms',
}

lines = File.readlines(CONSTANTS[:file], chomp:true)

separator = lines.map.with_index { |line, i| line.empty? ? i : nil }.compact.first

WIRE_REGEX = /(?<wire>\w+): (?<value>[01])/

WireBit = Data.define(:wire, :bit, :value)

def bits_from(wires, prefix)
  wires
    .select { |wire, _| wire.start_with?(prefix) }
    .sort
    .reverse
    .map { |wire, value| WireBit.new wire, wire[1..].to_i, value.to_i }
end

def number_from(wires, prefix)
  bits_from(wires, prefix).reduce(0) do |acc, wire_bit|
    acc | (wire_bit.value << wire_bit.bit)
  end
end

wires = lines[...separator]
          .map { |line| WIRE_REGEX.match(line) }
          .compact
          .reduce({}) do |hash, match|
            hash[match[:wire]] = match[:value].to_i
            hash
          end

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

def simulate(wires, gates)
  while gates.any?(&:indeterminate?)
    old_count = gates.count(&:indeterminate?)

    gates.select(&:indeterminate?).each { |gate| gate.check(wires) }

    # break if gates.count(&:indeterminate?) == old_count
    raise "simulation stalls with #{old_count} gates left" if gates.count(&:indeterminate?) == old_count
  end
end

def swap_and_simulate(wires, gates, pairs = [])
  cloned_wires = wires.clone
  cloned_gates = gates.collect(&:clone)

  pairs
    .map do |pair|
      pair.map do |output|
        cloned_gates.find { |gate| gate.output == output }
      end
    end
    .each do |pair|
      pair[0].output, pair[1].output = pair[1].output, pair[0].output
    end

  simulate(cloned_wires, cloned_gates)

  cloned_wires
end

def dfs(gates, wire)
  gate = gates.find { |gate| gate.output == wire }

  return [] unless gate

  [gate] + dfs(gates, gate.input1) + dfs(gates, gate.input2)
end

swaps = [
  ['z08', 'ffj'],
  ['dwp', 'kfm'],
  ['z22', 'gjh'],
  ['jdr', 'z31'],
]

puts '0s + 0s'
puts '-------'

zeroes_plus_zeroes_wires = wires.collect { |k, v| [k, 0] }.to_h
expected_z_bits = (0..45).to_a.reverse.map { |n| WireBit.new format('z%02d', n), n, 0 }

simulated_wires = swap_and_simulate(zeroes_plus_zeroes_wires, gates, swaps)
z_bits = bits_from(simulated_wires, 'z')

compare_bits = expected_z_bits.zip(z_bits)
first_bad_bit = compare_bits.reverse.find { |expected, actual| expected != actual }&.first&.bit

puts 'expected: ' + expected_z_bits.map(&:value).join
puts '  actual: ' + z_bits.map(&:value).join
puts ' compare: ' + compare_bits.map { |expected, actual| (expected != actual) ? '^' : ' ' }.join

if first_bad_bit
  puts "first bad bit: #{first_bad_bit}"
  good_gates = (0...first_bad_bit).map { |n| format('z%02d', n) }.map { |wire| dfs(gates, wire) }.flatten.uniq
  bad_gates = dfs(gates, format('z%02d', first_bad_bit)) - good_gates

  puts 'possible bad gates:'
  puts bad_gates
end

puts

puts '0s + 1s'
puts '-------'

zeroes_plus_ones_wires = wires.collect { |k, v| [k, k.start_with?('x') ? 0 : 1] }.to_h
expected_z_bits = [WireBit.new('z45', 45, 0)] + (0..44).to_a.reverse.map { |n| WireBit.new format('z%02d', n), n, 1 }

simulated_wires = swap_and_simulate(zeroes_plus_ones_wires, gates, swaps)
z_bits = bits_from(simulated_wires, 'z')

compare_bits = expected_z_bits.zip(z_bits)
first_bad_bit = compare_bits.reverse.find { |expected, actual| expected != actual }&.first&.bit

puts 'expected: ' + expected_z_bits.map(&:value).join
puts '  actual: ' + z_bits.map(&:value).join
puts ' compare: ' + compare_bits.map { |expected, actual| (expected != actual) ? '^' : ' ' }.join

if first_bad_bit
  puts "first bad bit: #{first_bad_bit}"
  good_gates = (0...first_bad_bit).map { |n| format('z%02d', n) }.map { |wire| dfs(gates, wire) }.flatten.uniq
  bad_gates = dfs(gates, format('z%02d', first_bad_bit)) - good_gates

  puts 'possible bad gates:'
  puts bad_gates
end

puts

puts '1s + 0s'
puts '-------'

ones_plus_zeroes_wires = wires.collect { |k, v| [k, k.start_with?('x') ? 1 : 0] }.to_h
expected_z_bits = [WireBit.new('z45', 45, 0)] + (0..44).to_a.reverse.map { |n| WireBit.new format('z%02d', n), n, 1 }

simulated_wires = swap_and_simulate(ones_plus_zeroes_wires, gates, swaps)
z_bits = bits_from(simulated_wires, 'z')

compare_bits = expected_z_bits.zip(z_bits)
first_bad_bit = compare_bits.reverse.find { |expected, actual| expected != actual }&.first&.bit

puts 'expected: ' + expected_z_bits.map(&:value).join
puts '  actual: ' + z_bits.map(&:value).join
puts ' compare: ' + compare_bits.map { |expected, actual| (expected != actual) ? '^' : ' ' }.join

if first_bad_bit
  puts "first bad bit: #{first_bad_bit}"
  good_gates = (0...first_bad_bit).map { |n| format('z%02d', n) }.map { |wire| dfs(gates, wire) }.flatten.uniq
  bad_gates = dfs(gates, format('z%02d', first_bad_bit)) - good_gates

  puts 'possible bad gates:'
  puts bad_gates
end

puts

puts '1s + 1s'
puts '-------'

ones_plus_ones_wires = wires.collect { |k, v| [k, 1] }.to_h
expected_z_bits = (1..45).to_a.reverse.map { |n| WireBit.new format('z%02d', n), n, 1 } + [WireBit.new('z00', 0, 0)]

simulated_wires = swap_and_simulate(ones_plus_ones_wires, gates, swaps)
z_bits = bits_from(simulated_wires, 'z')

compare_bits = expected_z_bits.zip(z_bits)
first_bad_bit = compare_bits.reverse.find { |expected, actual| expected != actual }&.first&.bit

puts 'expected: ' + expected_z_bits.map(&:value).join
puts '  actual: ' + z_bits.map(&:value).join
puts ' compare: ' + compare_bits.map { |expected, actual| (expected != actual) ? '^' : ' ' }.join

if first_bad_bit
  puts "first bad bit: #{first_bad_bit}"
  good_gates = (0...first_bad_bit).map { |n| format('z%02d', n) }.map { |wire| dfs(gates, wire) }.flatten.uniq
  bad_gates = dfs(gates, format('z%02d', first_bad_bit)) - good_gates

  puts 'possible bad gates:'
  puts bad_gates
end

puts

puts 'Numbers'
puts '-------'

x = number_from(wires, 'x')
y = number_from(wires, 'y')
expected_z = x + y

expected_z_bits = (0..45).to_a.reverse.map { |n| WireBit.new format('z%02d', n), n, (expected_z & (1 << n)).positive? ? 1 : 0 }

simulated_wires = swap_and_simulate(wires, gates, swaps)
z_bits = bits_from(simulated_wires, 'z')

compare_bits = expected_z_bits.zip(z_bits)
first_bad_bit = compare_bits.reverse.find { |expected, actual| expected != actual }&.first&.bit

puts 'expected: ' + expected_z_bits.map(&:value).join
puts '  actual: ' + z_bits.map(&:value).join
puts ' compare: ' + compare_bits.map { |expected, actual| (expected != actual) ? '^' : ' ' }.join

if first_bad_bit
  puts "first bad bit: #{first_bad_bit}"
  good_gates = (0...first_bad_bit).map { |n| format('z%02d', n) }.map { |wire| dfs(gates, wire) }.flatten.uniq
  bad_gates = dfs(gates, format('z%02d', first_bad_bit)) - good_gates

  puts 'possible bad gates:'
  puts bad_gates
end

puts

# first_bad_bit = 31

if first_bad_bit
  (0..first_bad_bit)
    .map { |n| format('z%02d', n) }
    .reduce([]) do |previous_gates, wire|
    gates_so_far = dfs(gates, wire)

    puts wire
    puts gates_so_far - previous_gates
    puts

    gates_so_far
  end
end

answer = swaps.flatten.sort.join(',')

puts "Answer: #{answer}"
