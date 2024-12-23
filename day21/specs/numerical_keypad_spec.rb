require './numerical_keypad'

RSpec.describe NumericalKeypad do
  subject(:keypad) { described_class.new nil }

  context "code 029A" do
    [
      ['A', '0', [['<']]],
      ['0', '2', [['^']]],
      ['2', '9', [['^', '^', '>'], ['>', '^', '^']]],
      ['9', 'A', [['v', 'v', 'v']]],
    ].each do |from, to, expected_movements|
      describe "when moving from key #{from} to key #{to}" do
        subject { keypad.move(from, to) }
        it { is_expected.to eq expected_movements }
      end
    end

    describe '#press_sequence' do
      subject { keypad.press_sequence code }

      let(:code) { '029A' }
      let(:expected_sequences) do
        [
          '<A^A^^>AvvvA',
          '<A^A>^^AvvvA',
        ]
      end
      let(:expected_shortest_sequence) { expected_sequences.map(&:size).min }

      it { is_expected.to eq expected_shortest_sequence }
    end
  end

  context "code 379A" do
    [
      ['A', '3', [['^']]],
      ['3', '7', [['^', '^', '<', '<'], ['<', '<', '^', '^']]],
      ['7', '9', [['>', '>']]],
      ['9', 'A', [['v', 'v', 'v']]],
    ].each do |from, to, expected_movements|
      describe "when moving from key #{from} to key #{to}" do
        subject { keypad.move(from, to) }
        it { is_expected.to eq expected_movements }
      end
    end
  end

  describe "#coord_for" do
    [
      ['A', Coord.new(3, 2)],
      ['0', Coord.new(3, 1)],
      ['1', Coord.new(2, 0)],
      ['2', Coord.new(2, 1)],
      ['3', Coord.new(2, 2)],
      ['4', Coord.new(1, 0)],
      ['5', Coord.new(1, 1)],
      ['6', Coord.new(1, 2)],
      ['7', Coord.new(0, 0)],
      ['8', Coord.new(0, 1)],
      ['9', Coord.new(0, 2)],
    ].each do |key, expected_coord|
      context "with key #{key}" do
        subject { keypad.coord_for(key) }
        it { is_expected.to eq expected_coord }
      end
    end
  end

  describe "#key_for" do
    [
      [Coord.new(3, 2), 'A'],
      [Coord.new(3, 1), '0'],
      [Coord.new(2, 0), '1'],
      [Coord.new(2, 1), '2'],
      [Coord.new(2, 2), '3'],
      [Coord.new(1, 0), '4'],
      [Coord.new(1, 1), '5'],
      [Coord.new(1, 2), '6'],
      [Coord.new(0, 0), '7'],
      [Coord.new(0, 1), '8'],
      [Coord.new(0, 2), '9'],
    ].each do |coord, expected_key|
      context "with coord #{coord}" do
        subject { keypad.key_for(coord) }
        it { is_expected.to eq expected_key }
      end
    end
  end
end
