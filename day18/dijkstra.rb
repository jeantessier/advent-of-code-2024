require './coord'

module Dijkstra
  def self.dijkstra(map, x_range, y_range)
    distances = Array.new(y_range.size) do |_|
      Array.new(x_range.size)
    end

    distances[0][0] = 0

    candidates = Coord.new(0, 0).neighbors
    until candidates.empty?
      candidate = candidates.shift

      neighbors = candidate.neighbors.reject { |neighbor| map[neighbor.y][neighbor.x] == '#' }.reject { |neighbor| candidates.include?(neighbor) }

      distances[candidate.y][candidate.x] = neighbors.map { |neighbor| distances[neighbor.y][neighbor.x] }.compact.min + 1

      candidates += neighbors.select { |neighbor| distances[neighbor.y][neighbor.x].nil? }
    end

    distances
  end

  def self.print(map, out = $stdout)
    map.each do |row|
      out.puts '| ' + row.map { |d| d.nil? ? '---' : format('%3d', d) }.join(' | ') + ' |'
    end
  end
end
