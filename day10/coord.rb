Coord = Struct.new(:x, :y, :x_range, :y_range) do
  def to_s
    "(#{x}, #{y})"
  end

  def up = Coord.new(x - 1, y, x_range, y_range)
  def right = Coord.new(x, y + 1, x_range, y_range)
  def down = Coord.new(x + 1, y, x_range, y_range)
  def left = Coord.new(x, y - 1, x_range, y_range)

  def valid?
    x_range.cover?(x) && y_range.cover?(y)
  end
end
