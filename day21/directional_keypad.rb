require './coord'
require './keypad'

class DirectionalKeypad < Keypad
  KEYS = [
                            ['^', Coord.new(0, 1)], ['A', Coord.new(0, 2)],
    ['<', Coord.new(1, 0)], ['v', Coord.new(1, 1)], ['>', Coord.new(1, 2)],
  ]
  def initialize
    super

    @key_to_coord = KEYS.to_h
    @coord_to_key = KEYS.map(&:reverse).to_h
  end
end
