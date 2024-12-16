#!/usr/bin/env ruby

# Login to https://adventofcode.com/2024/day/16/input to download 'input.txt'.

# lines = readlines
lines = File.readlines('sample1.txt') # Answer: 7036 (in 73 ms) **77 cycles** **285 paths**
# lines = File.readlines('sample2.txt') # Answer: 11048 (in 74 ms) **98 cycles** **122 paths**
# lines = File.readlines('input.txt') # Answer: ?? (in ?? ms)

# Renders the map (on *STDOUT* by default)
def print_map(map, out = $stdout)
  map.each do |row|
    out.puts row.join
  end
end

map = lines.map(&:chomp).map { |line| line.split('') }

puts 'Map'
puts '---'
print_map(map)
puts

Vertex = Data.define(:x, :y) do
  def to_s
    "(#{x}, #{y})"
  end
end

Edge = Data.define(:v1, :v2) do
  def cost
    (v2.y - v1.y) + (v2.x - v1.x)
  end

  def include?(vertex)
    v1 == vertex || v2 == vertex
  end

  def to_s
    "#{v1} -- #{v2} [#{cost}]"
  end
end

def find_neighbors(map, x, y)
  [
    map[x-1][y] == '.' ? 'N' : nil,
    map[x][y+1] == '.' ? 'E' : nil,
    map[x+1][y] == '.' ? 'S' : nil,
    map[x][y-1] == '.' ? 'W' : nil,
  ].compact
end

start_vertex = map.collect.with_index do |row, x|
  row.collect.with_index do |cell, y|
    cell == 'S' ? Vertex.new(x, y) : nil
  end
end.flatten.compact.first

middle_vertices = map.collect.with_index do |row, x|
  row.collect.with_index do |cell, y|
    if cell == '.'
      neighbors = find_neighbors(map, x, y)
      case neighbors.size
      when 0 then nil
      when 1 then nil
      when 2 then ['NS', 'EW'].include?(neighbors.join) ? nil : Vertex.new(x, y)
      when 3 then Vertex.new(x, y)
      when 4 then Vertex.new(x, y)
      end
    end
  end
end.flatten.compact

end_vertex = map.collect.with_index do |row, x|
  row.collect.with_index do |cell, y|
    cell == 'E' ? Vertex.new(x, y) : nil
  end
end.flatten.compact.first

# puts 'Start Vertex'
# puts '------------'
# puts start_vertex
# puts
#
# puts "Middle Vertices (#{middle_vertices.size})"
# puts '---------------'
# puts middle_vertices
# puts
#
# puts 'End Vertex'
# puts '----------'
# puts end_vertex
# puts

vertices = [start_vertex] + middle_vertices + [end_vertex]

puts "Vertices (#{vertices.size})"
puts '--------'
puts

horizontal_edges = (1...(map.size)).collect do |x|
  vertices_subset = vertices.select { |v| v.x == x }

  vertices_subset
    .product(vertices_subset)
    .select { |v1, v2| v1.y < v2.y }
    .reject { |v1, v2| map[x][(v1.y)..(v2.y)].any?('#') }
    .collect { |v1, v2| Edge.new(v1, v2) }
end.flatten

# puts "Horizontal Edges (#{horizontal_edges.size})"
# puts '----------------'
# puts horizontal_edges
# puts

vertical_edges = (1...(map.first.size)).collect do |y|
  vertices_subset = vertices.select { |v| v.y == y }

  vertices_subset
    .product(vertices_subset)
    .select { |v1, v2| v1.x < v2.x }
    .reject { |v1, v2| map[(v1.x)..(v2.x)].map { |row| row[y] }.any?('#') }
    .collect { |v1, v2| Edge.new(v1, v2) }
end.flatten

# puts "Vertical Edges (#{vertical_edges.size})"
# puts '--------------'
# puts vertical_edges
# puts

edges = horizontal_edges + vertical_edges

puts "Edges (#{edges.size})"
puts '-----'
puts

possible_scores = []

puts 'Possible Scores'
puts '---------------'
puts possible_scores.inspect
puts

lowest_score = possible_scores.min

puts "Lowest Score: #{lowest_score}"
