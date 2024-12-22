require './coord'
require './keypad'

class DirectionalKeypad < Keypad
  KEYS = [
                            ['^', Coord.new(0, 1)], ['A', Coord.new(0, 2)],
    ['<', Coord.new(1, 0)], ['v', Coord.new(1, 1)], ['>', Coord.new(1, 2)],
  ]
  def initialize(delegate)
    super(delegate, KEYS)
  end
end
