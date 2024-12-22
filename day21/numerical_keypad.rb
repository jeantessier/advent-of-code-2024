require './coord'
require './keypad'

class NumericalKeypad < Keypad
  KEYS = [
    ['7', Coord.new(0, 0)], ['8', Coord.new(0, 1)], ['9', Coord.new(0, 2)],
    ['4', Coord.new(1, 0)], ['5', Coord.new(1, 1)], ['6', Coord.new(1, 2)],
    ['1', Coord.new(2, 0)], ['2', Coord.new(2, 1)], ['3', Coord.new(2, 2)],
                            ['0', Coord.new(3, 1)], ['A', Coord.new(3, 2)],
  ]
  def initialize(delegate)
    super(delegate, KEYS)
  end
end
