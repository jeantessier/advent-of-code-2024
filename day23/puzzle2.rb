#!/usr/bin/env ruby

# Login to https://adventofcode.com/2024/day/23/input to download 'input.txt'.

# lines = readlines
# lines = File.readlines('sample.txt', chomp: true) # Answer: co,de,ka,ta (in 61 ms)
lines = File.readlines('input.txt', chomp: true) # Answer: gt,ha,ir,jn,jq,kb,lr,lt,nl,oj,pp,qh,vy (in 74 ms)

network = lines
  .map { |line| line.split('-') }
  .reduce(Hash.new { |hash, key| hash[key] = [] }) { |hash, pair| hash[pair[0]] << pair[1]; hash[pair[1]] << pair[0]; hash }

puts "Network (#{network.select { |computer, _| computer.start_with?('t') }.size} / #{network.size})"
puts '-------'
network.sort.select { |computer, _| computer.start_with?('t') }.each do |computer, connections|
  puts "#{computer} is connected to #{connections.sort} (#{connections.size})"
end
puts

def cannon(c1, c2)
  c1 < c2 ? "#{c1}-#{c2}" : "#{c2}-#{c1}"
end

cannonical_connections = lines
                           .map { |line| line.split('-') }
                           .map { |c1, c2| cannon(c1, c2) }
                           .to_set

puts "Cannonical Connections (#{cannonical_connections.size})"
puts '----------------------'
puts '...'
puts

lan_parties = network
                # .select { |computer, _| computer.start_with?('t') } # Assumption: the largest LAN party will include a computer starting with 't'
                .collect do |computer, connections|
                  lan_party = [computer]
                  connections.each do |c1|
                    if lan_party.all? { |c2| cannonical_connections.include?(cannon(c1, c2)) }
                      lan_party << c1
                    end
                  end

                  lan_party
                end

sorted_lan_parties = lan_parties
                       .map(&:sort)
                       .map { |lan_party| lan_party.join(',') }
                       .uniq
                       .sort_by(&:size)

puts
puts "LAN Parties (#{lan_parties.size})"
puts '-----------'
puts sorted_lan_parties.take(5)
puts '...'
puts sorted_lan_parties.reverse.take(5).reverse
puts

puts "Answer: #{sorted_lan_parties.last}"
