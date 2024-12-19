#!/usr/bin/env ruby

require './computer'

# Login to https://adventofcode.com/2024/day/17/input to download 'input.txt'.

# lines = readlines
# lines = File.readlines('sample2.txt', chomp: true) # Answer: 117440 (in 58 ms)
lines = File.readlines('input.txt', chomp: true) # Answer: 164516454365621 (in 131 ms)

separators = lines.map.with_index { |line, i| line.empty? ? i : nil }.compact

REGISTER_REGEX = /Register (?<register>\w): (?<value>\d+)/

init_state = lines[0...(separators.first)]
               .map { |line| REGISTER_REGEX.match(line) }
               .compact
               .reduce({}) do |acc, m|
                 acc[m[:register]] = m[:value].to_i
                 acc
               end

PROGRAM_REGEX = /Program: (?<program>(\d+,)*\d+)/

program = PROGRAM_REGEX.match(lines[separators.first + 1])[:program].split(',').map(&:to_i)

OCTAL_DIGITS = ('0'..'7').collect { |d| d }

candidates = program.size.times.collect { |n| n }.reverse.reduce(['']) do |acc, n|
  puts "#{n}: #{program.drop(n)}"

  acc
    .product(OCTAL_DIGITS)
    .map { |prefix, digit| prefix + digit }
    .select do |candidate|
      register_a = candidate.oct

      computer = Computer.new(register_a, init_state['B'], init_state['C'], log: nil)
      computer.run(program)
      computer.output == program.drop(n)
    end
end
puts

puts 'Candidates'
puts '----------'
candidates.each do |candidate|
  puts "0#{candidate} ==> #{candidate.oct}"
end
puts

# (0...0100000000).each do |candidate|
# (0453200..0453207).each do |candidate|
#
#   # register_a = ([candidate] + values).reduce do |acc, value|
#   #   acc = (acc << 3) + value
#   #   acc
#   # end
#
#   # register_a = (candidate.to_s + values.join).oct
#   register_a = candidate
#
#   computer = Computer.new(register_a, init_state['B'], init_state['C'], log: nil)
#
#   computer.run(program)
#
#   # if computer.output == program[0..(computer.output.size - 1)]
#     puts "candidate #{format('0%o', candidate)}: Register A: #{register_a} --> Output: #{computer.output.join(',')}"
#   # end
# end

puts "Answer: #{candidates.map(&:oct).min}"
