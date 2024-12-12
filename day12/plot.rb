Plot = Struct.new(:x, :y, :garden) do
  def type_of_plant
    @type_of_plant ||= garden[x][y]
  end

  def up
    Plot.new(x - 1, y, garden) if valid?(x - 1, y)
  end

  def right
    Plot.new(x, y + 1, garden) if valid?(x, y + 1)
  end

  def down
    Plot.new(x + 1, y, garden) if valid?(x + 1, y)
  end

  def left
    Plot.new(x, y - 1, garden) if valid?(x, y - 1)
  end

  def neighbors = [up, right, down, left].compact

  def valid?(x = nil, y = nil)
    x ||= self.x
    y ||= self.y

    x_range.cover?(x) && y_range.cover?(y)
  end

  def x_range = @x_range ||= 0...garden.size
  def y_range = @y_range ||= 0...garden.first.size

  def fences
    4 - neighbors.select { |neighbor| neighbor.type_of_plant == type_of_plant }.size
  end

  def to_s
    "(#{x}, #{y}) #{type_of_plant} [#{fences}]"
  end
end
