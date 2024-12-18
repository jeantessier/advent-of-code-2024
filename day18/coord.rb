Coord = Data.define(:x, :y) do
  def up = Coord.new(x - 1, y)
  def right = Coord.new(x, y + 1)
  def down = Coord.new(x + 1, y)
  def left = Coord.new(x, y - 1)

  def valid? = CONSTANTS[:x_range].include?(x) && CONSTANTS[:y_range].include?(y)

  def neighbors
    [up, right, down, left].select(&:valid?)
  end

  def to_s
    "(#{x}, #{y})"
  end
end
