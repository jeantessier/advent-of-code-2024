Vector = Data.define(:start_pos, :end_pos) do
  def vertical_corner
    Coord.new(end_pos.x, start_pos.y)
  end

  def horizontal_corner
    Coord.new(start_pos.x, end_pos.y)
  end

  def x_movements
    delta = end_pos.x - start_pos.x
    distance = delta.abs
    direction = delta == distance ? 'v' : '^'

    distance.times.collect { |_| direction }
  end

  def y_movements
    delta = end_pos.y - start_pos.y
    distance = delta.abs
    direction = delta == distance ? '>' : '<'

    distance.times.collect { |_| direction }
  end

  def to_s
    "#{start_pos} --> #{end_pos}"
  end
end
