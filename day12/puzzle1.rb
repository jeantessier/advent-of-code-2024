#!/usr/bin/env ruby

require './plot'
require './region'

# Login to https://adventofcode.com/2024/day/12/input to download 'input.txt'.

# lines = readlines
# lines = File.readlines('sample1.txt', chomp: true) # Answer: 140 (in 61 ms)
# lines = File.readlines('sample2.txt', chomp: true) # Answer: 772 (in 61 ms)
# lines = File.readlines('sample3.txt', chomp: true) # Answer: 1930 (in 47 ms)
lines = File.readlines('input.txt', chomp: true) # Answer: 1363484 (in 4,231 ms)

# Renders the map (on *STDOUT* by default)
def print_map(map, out = $stdout)
  map.each do |row|
    out.puts row.join
  end
end

map = lines.map { |line| line.split('') }

puts 'Map'
puts '---'
print_map(map)
puts

x_range = 0...map.size
y_range = 0...map.first.size

puts 'Ranges'
puts '------'
puts "#{x_range.size} x #{y_range.size}"
puts "x_range: #{x_range}"
puts "y_range: #{y_range}"
puts

plots = x_range.collect do |x|
  y_range.collect do |y|
    Plot.new(x, y, map)
  end
end.flatten.group_by(&:type_of_plant)

puts 'Plots'
puts '-----'
plots.each do |type_of_plant, plots|
  puts type_of_plant
  plots.each do |plot|
    puts "  #{plot} -> #{plot.neighbors.map(&:to_s)}"
  end
end
puts

regions = plots.collect do |type_of_plant, plots|
  visited = []
  result = []

  # puts "Looking for regions of #{type_of_plant} in plots #{plots.map { |p| "(#{p.x}, #{p.y})" }.join(', ')}"

  until plots.all? { |p| visited.include?(p) }
    (plots - visited).each do |plot|
      next if visited.include?(plot)

      region = Region.new(type_of_plant)
      # puts "  Starting a region of #{type_of_plant}"

      constituents = [plot]
      until constituents.empty?
        # puts "    constituents: [#{constituents.map(&:to_s).join(', ')}]"

        constituent = constituents.pop
        # puts "    constituent: #{constituent}"

        region.plots << constituent
        visited << constituent

        new_constituents = constituent.neighbors.select { |p| p.type_of_plant == type_of_plant && !visited.include?(p) && !constituents.include?(p) }
        # puts "    adding constituents: [#{new_constituents.map(&:to_s).join(', ')}]"
        constituents += new_constituents
      end

      # puts "Created region #{region}"

      result << region
    end
  end

  result
end.flatten

puts 'Regions'
puts '-------'
regions.each { |region| puts "#{region} has an area of #{region.area}, a perimeter of #{region.perimeter}, and costs #{region.price}" }
puts

puts "Total: #{regions.map(&:price).sum}"
