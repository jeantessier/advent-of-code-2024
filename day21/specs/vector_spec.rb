require './coord'
require './vector'

describe Vector do
  let(:origin) { Coord.new(0, 0) }

  context 'with size zero' do
    let(:vector) { described_class.new(origin, origin) }

    context '#x_movements' do
      subject { vector.x_movements }
      it { is_expected.to eq [] }
    end

    context '#y_movements' do
      subject { vector.y_movements }
      it { is_expected.to eq [] }
    end

    describe '#vertical_corner' do
      subject { vector.vertical_corner }
      it { is_expected.to eq origin }
    end

    describe '#horizontal_corner' do
      subject { vector.horizontal_corner }
      it { is_expected.to eq origin }
    end
  end

  [
    ['North',     Coord.new(-2, 0),  ['^', '^'], [],         Coord.new(-2, 0), Coord.new(0, 0)],
    ['Northwest', Coord.new(-2, -2), ['^', '^'], ['<', '<'], Coord.new(-2, 0), Coord.new(0, -2)],
    ['West',      Coord.new(0, -2),  [],         ['<', '<'], Coord.new(0, 0),  Coord.new(0, -2)],
    ['Southwest', Coord.new(2, -2),  ['v', 'v'], ['<', '<'], Coord.new(2, 0),  Coord.new(0, -2)],
    ['South',     Coord.new(2, 0),   ['v', 'v'], [],         Coord.new(2, 0),  Coord.new(0, 0)],
    ['Southeast', Coord.new(2, 2),   ['v', 'v'], ['>', '>'], Coord.new(2, 0),  Coord.new(0, 2)],
    ['East',      Coord.new(0, 2),   [],         ['>', '>'], Coord.new(0, 0),  Coord.new(0, 2)],
    ['Northeast', Coord.new(-2, 2),  ['^', '^'], ['>', '>'], Coord.new(-2, 0), Coord.new(0, 2)],
  ].each do |variation, end_pos, expected_x_movements, expected_y_movements, expected_vertical_corner, expected_horizontal_corner|
    context "when pointing #{variation}" do
      subject(:vector) { described_class.new(origin, end_pos) }

      describe '#x_movements' do
        subject { vector.x_movements }
        it { is_expected.to eq expected_x_movements }
      end

      describe '#y_movements' do
        subject { vector.y_movements }
        it { is_expected.to eq expected_y_movements }
      end

      describe '#vertical_corner' do
        subject { vector.vertical_corner }
        it { is_expected.to eq expected_vertical_corner }
      end

      describe '#horizontal_corner' do
        subject { vector.horizontal_corner }
        it { is_expected.to eq expected_horizontal_corner }
      end
    end
  end
end
