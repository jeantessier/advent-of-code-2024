Coord = Data.define(:map, :x, :y) do
  def up = Coord.new(map, x - 1, y)
  def right = Coord.new(map, x, y + 1)
  def down = Coord.new(map, x + 1, y)
  def left = Coord.new(map, x, y - 1)

  def neighbors
    [up, right, down, left].select(&:track?)
  end

  def walls
    [up, right, down, left].select(&:valid?).reject(&:track?)
  end

  def track?
    map[x][y] != '#'
  end

  def valid?
    x.respond_to? && x < (map.size - 1) && y.positive? && y < (map.first.size - 1)
  end

  def -(other)
    case
    when x - 1 == other.x && y == other.y then :up
    when x == other.x && y + 1 == other.y then :right
    when x + 1 == other.x && y == other.y then :down
    when x == other.x && y - 1 == other.y then :left
    else raise "Invalid difference between #{self} and #{other}"
    end
  end

  def to_s
    "(#{x}, #{y})"
  end
end
