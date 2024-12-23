#!/usr/bin/env ruby

# Login to https://adventofcode.com/2024/day/23/input to download 'input.txt'.

# lines = readlines
# lines = File.readlines('sample.txt', chomp: true) # Answer: 7 (in 54 ms)
lines = File.readlines('input.txt', chomp: true) # Answer: 1423 (in 60 ms)

network = lines
  .map { |line| line.split('-') }
  .reduce(Hash.new { |hash, key| hash[key] = [] }) { |hash, pair| hash[pair[0]] << pair[1]; hash[pair[1]] << pair[0]; hash }

puts "Network (#{network.size})"
puts '-------'
network.sort.select { |computer, _| computer.start_with?('t') }.each do |computer, connections|
  puts "#{computer} is connected to #{connections.sort} (#{connections.size})"
end
puts

triplets = network
             .select { |computer, _| computer.start_with?('t') }
             .collect do |computer, connections|
               connections.collect do |connection|
                 connections
                   .intersection(network[connection])
                   .collect { |third| [computer, connection, third] }
                   .map(&:sort)
                   .map { |triplet| triplet.join(',') }
               end
             end
             .flatten
             .uniq

puts "Triplets (#{triplets.size})"
puts '-------'
puts triplets.sort
puts

answer = triplets.size

puts "Answer: #{answer}"
