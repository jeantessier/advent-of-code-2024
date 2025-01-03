#!/usr/bin/env ruby

START = Time.now

def timestamp(msg = '')
  puts sprintf("T+ %0.3f ms: %s", (Time.now - START) * 1_000, msg)
end

# Login to https://adventofcode.com/2024/day/16/input to download 'input.txt'.

# lines = readlines
# lines = File.readlines('sample1.txt', chomp: true) # Answer: 45 (in 42 ms)
# lines = File.readlines('sample2.txt', chomp: true) # Answer: 64 (in 63 ms)
lines = File.readlines('input.txt', chomp: true) # Answer: 479 (in ?? ms)

# Renders the map (on *STDOUT* by default)
def print_map(map, out = $stdout)
  map.each do |row|
    out.puts row.join
  end
end

map = lines.map { |line| line.split('') }

timestamp
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

vertices = [start_vertex] + middle_vertices + [end_vertex]

timestamp
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

vertical_edges = (1...(map.first.size)).collect do |y|
  vertices_subset = vertices.select { |v| v.y == y }

  vertices_subset
    .product(vertices_subset)
    .select { |v1, v2| v1.x < v2.x }
    .reject { |v1, v2| map[(v1.x)..(v2.x)].map { |row| row[y] }.any?('#') }
    .collect { |v1, v2| Edge.new(v1, v2) }
end.flatten

edges = horizontal_edges + vertical_edges

timestamp
puts "Edges (#{edges.size})"
puts '-----'
puts

vertex_edges = edges.reduce(Hash.new { |h, k| h[k] = [] }) do |hash, edge|
  hash[edge.v1] << edge
  hash[edge.v2] << edge
  hash
end

timestamp
puts 'Starting Edges'
puts '--------------'
puts vertex_edges[start_vertex]
puts

timestamp
puts 'Ending Edges'
puts '------------'
puts vertex_edges[end_vertex]
puts

def select_edges(start_vertex, edges, end_vertex)
  selected_edges = []
  visited_vertices = [start_vertex]

  until visited_vertices.include?(end_vertex)
    border_edges = edges.select do |edge|
      visited_v1 = visited_vertices.include?(edge.v1)
      visited_v2 = visited_vertices.include?(edge.v2)
      (visited_v1 && !visited_v2) || (!visited_v1 && visited_v2)
    end

    selected_edges += border_edges

    border_edges.each do |edge|
      visited_vertices << edge.v1 unless visited_vertices.include?(edge.v1)
      visited_vertices << edge.v2 unless visited_vertices.include?(edge.v2)
    end
  end

  { vertices: visited_vertices, edges: selected_edges }
end

# Cut off exploratory branches that don't connect.
# We repeatedly find terminal vertices and prune them.
# For edges on a connected path, each vertex will be part of at least two edges.
# Start and end vertices are "special" and should not be pruned.
def prune(vertices, edges, special_vertices)
  old_size = vertices.size

  loop do
    vertex_edges = edges.reduce(Hash.new { |h, k| h[k] = [] }) do |hash, edge|
      hash[edge.v1] << edge
      hash[edge.v2] << edge
      hash
    end

    # Find vertices with only one edge, remove them and their edge
    vertex_edges.reject { |k, _| special_vertices.include?(k) }.select { |_, v| v.size == 1 }.each do |k, v|
      vertices.delete(k)
      v.each { |edge| edges.delete(edge) }
    end

    if old_size != vertices.size
      old_size = vertices.size
    else
      break
    end
  end

  { vertices:, edges: }
end

searching_forward = select_edges(start_vertex, edges, end_vertex)

timestamp
puts 'Searching Forward'
puts '-----------------'
puts "vertices: #{searching_forward[:vertices].size} / #{vertices.size}"
puts "edges: #{searching_forward[:edges].size} / #{edges.size}"
puts

pruned_forward = prune(searching_forward[:vertices], searching_forward[:edges], [start_vertex, end_vertex])

timestamp
puts 'Pruned Forward'
puts '--------------'
puts "vertices: #{pruned_forward[:vertices].size} / #{searching_forward[:vertices].size} / #{vertices.size}"
puts "edges: #{pruned_forward[:edges].size} / #{searching_forward[:edges].size} / #{edges.size}"
puts

searching_backward = select_edges(end_vertex, edges, start_vertex)

timestamp
puts 'Searching Backward'
puts '------------------'
puts "vertices: #{searching_backward[:vertices].size} / #{vertices.size}"
puts "edges: #{searching_backward[:edges].size} / #{edges.size}"
puts

pruned_backward = prune(searching_backward[:vertices], searching_backward[:edges], [start_vertex, end_vertex])

timestamp
puts 'Pruned Backward'
puts '---------------'
puts "vertices: #{pruned_backward[:vertices].size} / #{searching_backward[:vertices].size} / #{vertices.size}"
puts "edges: #{pruned_backward[:edges].size} / #{searching_backward[:edges].size} / #{edges.size}"
puts

union = {
  vertices: (pruned_forward[:vertices] + pruned_backward[:vertices]).uniq,
  edges: (pruned_forward[:edges] + pruned_backward[:edges]).uniq,
}

timestamp
puts 'Union'
puts '-----'
puts "vertices: #{union[:vertices].size}"
puts "edges: #{union[:edges].size}"
puts

intersection = {
  vertices: pruned_forward[:vertices].intersection(pruned_backward[:vertices]),
  edges: pruned_forward[:edges].intersection(pruned_backward[:edges]),
}

timestamp
puts 'Intersection'
puts '------------'
puts "vertices: #{intersection[:vertices].size}"
puts "edges: #{intersection[:edges].size}"
puts

def score(path)
  ((path.size - 1) * 1000) + path.each_cons(2).map { |v1, v2| (v1.x - v2.x).abs + (v1.y - v2.y).abs }.sum
end

def find_paths(path_prefix, edges, end_vertex)

  if path_prefix.include?(end_vertex)
    timestamp "path_prefix.size = #{path_prefix.size}, edges.size = #{edges.size}, *** score = #{score(path_prefix)} ***"
    return [path_prefix]
  else
    timestamp "path_prefix.size = #{path_prefix.size}, edges.size = #{edges.size}"
  end

  edges
    .select { |edge| edge.include?(path_prefix.last) }
    .reject { |edge| path_prefix.include?(edge.v1) && path_prefix.include?(edge.v2) }
    .collect { |edge| find_paths(path_prefix + (path_prefix.include?(edge.v1) ? [edge.v2] : [edge.v1]), edges - [edge], end_vertex) }
    .flatten(1)
end

# possible_paths = find_paths([start_vertex], union[:edges], end_vertex)
# possible_paths = find_paths([start_vertex], intersection[:edges], end_vertex)
# possible_paths = find_paths([start_vertex], pruned_forward[:edges], end_vertex)

def find_paths2(path_prefix, edges, path_suffix)
  if path_prefix.last == path_suffix.first
    result = path_prefix + path_suffix[1..]
    timestamp "path_prefix.size = #{path_prefix.size}, path_suffix.size = #{path_suffix.size}, edges.size = #{edges.size}, *** score = #{score(result)} *** --NODE--"
    return [result]
  else
    timestamp "path_prefix.size = #{path_prefix.size}, path_suffix.size = #{path_suffix.size}, edges.size = #{edges.size}"
  end

  # Grow path_prefix
  edges_that_grow_prefix = edges
                             .select { |edge| edge.include?(path_prefix.last) }
                             .reject { |edge| path_prefix.include?(edge.v1) && path_prefix.include?(edge.v2) }

  # Grow path_suffix
  edges_that_grow_suffix = edges
                             .select { |edge| edge.include?(path_suffix.first) }
                             .reject { |edge| path_suffix.include?(edge.v1) && path_suffix.include?(edge.v2) }

  # One new edge connects the last vertex of the prefix to the first vertex of the suffix
  if edges_that_grow_prefix.any? { |edge| edge.v1 == path_suffix.first || edge.v2 == path_suffix.first }
    result = path_prefix + path_suffix
    timestamp "path_prefix.size = #{path_prefix.size}, path_suffix.size = #{path_suffix.size}, edges.size = #{edges.size}, *** score = #{score(result)} *** --EDGE--"
    return [result]
  end

  # Explore all combinations of growing prefix and suffix
  edges_that_grow_prefix
    .product(edges_that_grow_suffix)
    .reject { |prefix_edge, suffix_edge| path_prefix.include?(suffix_edge.v1) || path_prefix.include?(suffix_edge.v2) || path_suffix.include?(prefix_edge.v1) || path_suffix.include?(prefix_edge.v2) }
    .collect do |prefix_edge, suffix_edge|
      find_paths2(
        path_prefix + (path_prefix.include?(prefix_edge.v1) ? [prefix_edge.v2] : [prefix_edge.v1]),
        edges - [prefix_edge, suffix_edge],
        (path_suffix.include?(suffix_edge.v1) ? [suffix_edge.v2] : [suffix_edge.v1]) + path_suffix,
      )
    end
    .flatten(1)
end

# possible_paths = find_paths2([start_vertex], union[:edges], [end_vertex])
possible_paths = find_paths2([start_vertex], intersection[:edges], [end_vertex])
# possible_paths = find_paths2([start_vertex], pruned_forward[:edges], [end_vertex])

timestamp
puts "Possible Paths (#{possible_paths.size})"
puts '--------------'
# possible_paths.each { |path| puts path.join(' --> ') }
puts

possible_scores = possible_paths.map { |path| score(path) }

timestamp
puts 'Possible Scores'
puts '---------------'
puts possible_scores.inspect
puts

lowest_score = possible_scores.min

timestamp
puts "Lowest Score: #{lowest_score}"
puts

best_paths = possible_paths.select do |path|
  ((path.size - 1) * 1000) + path.each_cons(2).map { |v1, v2| (v1.x - v2.x).abs + (v1.y - v2.y).abs }.sum == lowest_score
end

timestamp
puts "Best Paths (#{best_paths.size})"
puts '--------------'
best_paths.each { |path| puts path.join(' --> ') }
puts

path_tiles = best_paths.map do |path|
  path
    .each_cons(2)
    .map do |v1, v2|
      x_range = ([v1.x, v2.x].min)..([v1.x, v2.x].max)
      y_range = ([v1.y, v2.y].min)..([v1.y, v2.y].max)
      x_range.collect { |x| y_range.collect { |y| Vertex.new(x, y) } }
    end
    .flatten
    .uniq
end

timestamp
puts 'Path Tiles'
puts '----------'
path_tiles.each { |tiles| puts tiles.size }
puts

tiles = path_tiles.flatten.uniq

tiles.each { |tile| map[tile.x][tile.y] = 'O' }

timestamp
puts 'Best Paths'
puts '----------'
print_map(map)
puts

total = tiles.size

timestamp
puts "Total: #{total}"
