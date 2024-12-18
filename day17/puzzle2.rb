#!/usr/bin/env ruby

require './reverse_computer'

# Login to https://adventofcode.com/2024/day/17/input to download 'input.txt'.

# lines = readlines
# lines = File.readlines('sample2.txt', chomp: true) # Answer: 117440 (in 58 ms)
lines = File.readlines('input.txt', chomp: true) # Answer: ?? (in ?? ms)

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

match = PROGRAM_REGEX.match(lines[separators.first + 1])
if match
  program = match[:program].split(',').map(&:to_i)

  catch :done do
    (0..3).each do |initial_b|
      (0..3).each do |initial_c|
        puts "initial Register B: #{initial_b} Register C: #{initial_c}"

        start = Time.now

        begin
          # log = $stdout
          log = nil

          reverse_computer = ReverseComputer.new(program, initial_b, initial_c, log:)
          reverse_computer.reverse_run(program)

          puts reverse_computer

          if reverse_computer.b == init_state['B'] && reverse_computer.c == init_state['C']
            throw :done
          end
        rescue StandardError => e
          puts "     #{e}"
        ensure
          puts format('     took %0.3f ms', (Time.now - start) * 1000)
        end
      end
    end
  end
end
