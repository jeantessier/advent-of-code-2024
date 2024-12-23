require './vector'

class Keypad
  attr_reader :delegate

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
      result << (vector.x_movements + vector.y_movements).join
    else
      unless key_in_vertical_corner.nil?
        result << (vector.x_movements + vector.y_movements).join
      end

      unless key_in_horizontal_corner.nil?
        result << (vector.y_movements + vector.x_movements).join
      end
    end

    result
  end

  def press_sequence(input_sequence)
    return @cache[input_sequence] if @cache.has_key?(input_sequence)

    @cache[input_sequence] = ('A' + input_sequence)
                               .split('')
                               .each_cons(2)
                               .collect { |from, to| move(from, to) }
                               .map { |sequences| sequences.map { |sequence| sequence + 'A' } }
                               .map { |sequences| delegate ?  sequences.map { |sequence| delegate.press_sequence(sequence) } : sequences.map(&:size) }
                               .map(&:min)
                               .sum
  end
end
