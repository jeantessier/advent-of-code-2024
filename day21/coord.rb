Coord = Data.define(:x, :y) do
  def to_s
    "(#{x}, #{y})"
  end
end
