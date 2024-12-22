require './vector'

class Keypad
  def initialize(delegate, keys)
    @delegate = delegate

    @key_to_coord = keys.to_h
    @coord_to_key = keys.map(&:reverse).to_h

    @cache = {}
  end

  def coord_for(key)
    @key_to_coord[key]
  end

  def key_for(coord)
    @coord_to_key[coord]
  end

  def move(from, to)
    vector = Vector.new(coord_for(from), coord_for(to))

    key_in_vertical_corner = key_for(vector.vertical_corner)
    key_in_horizontal_corner = key_for(vector.horizontal_corner)

    result = []

    if vector.x_movements.empty? || vector.y_movements.empty?
      result << (vector.x_movements + vector.y_movements)
    else
      unless key_in_vertical_corner.nil?
        result << (vector.x_movements + vector.y_movements)
      end

      unless key_in_horizontal_corner.nil?
        result << (vector.y_movements + vector.x_movements)
      end
    end

    result
  end

  def press_sequence(input_sequence)
    return @cache[input_sequence] if @cache.has_key?(input_sequence)

    possibilities = ('A' + input_sequence)
                      .split('')
                      .each_cons(2)
                      .collect { |from, to| move(from, to) }
                      .map { |sequences| sequences.map { |sequence| sequence << 'A' } }
                      .map { |sequences| sequences.map { |sequence| @delegate.nil? ? sequence : @delegate.press_sequence(sequence) } }

    @cache[input_sequence] = coalesce(possibilities).map(&:join)
  end

  def coalesce(sequences)
    return [] if sequences.empty?
    return sequences.first if sequences.size == 1

    head = sequences.first
    tail = sequences[1..]

    head
      .product(coalesce(tail))
      .collect { |head_sequence, tail_sequence| head_sequence + tail_sequence }
  end
end
