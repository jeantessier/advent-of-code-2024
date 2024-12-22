require './directional_keypad'

RSpec.describe DirectionalKeypad do
  subject(:keypad) { described_class.new }

  # These sequences come from trying to type '029A' on a numerical keypad.

  context "sequence <A" do
    [
      ['A', '<', [['v', '<', '<']]],
      ['<', 'A', [['>', '>', '^']]],
    ].each do |from, to, expected_movements|
      describe "when moving from key #{from} to key #{to}" do
        subject { keypad.move(from, to) }
        it { is_expected.to eq expected_movements }
      end
    end
  end

  context "sequence ^A" do
    [
      ['A', '^', [['<']]],
      ['^', 'A', [['>']]],
    ].each do |from, to, expected_movements|
      describe "when moving from key #{from} to key #{to}" do
        subject { keypad.move(from, to) }
        it { is_expected.to eq expected_movements }
      end
    end
  end

  context "sequence >^^A" do
    [
      ['A', '>', [['v']]],
      ['>', '^', [['^', '<'], ['<', '^']]],
      ['^', '^', [[]]],
      ['^', 'A', [['>']]],
    ].each do |from, to, expected_movements|
      describe "when moving from key #{from} to key #{to}" do
        subject { keypad.move(from, to) }
        it { is_expected.to eq expected_movements }
      end
    end
  end

  context "sequence vvvA" do
    [
      ['A', 'v', [['v', '<'], ['<', 'v']]],
      ['v', 'v', [[]]],
      ['v', 'v', [[]]],
      ['v', 'A', [['^', '>'], ['>', '^']]],
    ].each do |from, to, expected_movements|
      describe "when moving from key #{from} to key #{to}" do
        subject { keypad.move(from, to) }
        it { is_expected.to eq expected_movements }
      end
    end

    describe '#press_sequence' do
      subject { keypad.press_sequence code }

      let(:code) { 'vvvA' }
      let(:expected_sequences) do
        [
          'v<AAA^>A',
          'v<AAA>^A',
          '<vAAA^>A',
          '<vAAA>^A',
        ]
      end

      it { is_expected.to eq expected_sequences }
    end
  end

  describe "#coord_for" do
    [
      ['A', Coord.new(0, 2)],
      ['^', Coord.new(0, 1)],
      ['<', Coord.new(1, 0)],
      ['v', Coord.new(1, 1)],
      ['>', Coord.new(1, 2)],
    ].each do |key, expected_coord|
      context "with key #{key}" do
        subject { keypad.coord_for(key) }
        it { is_expected.to eq expected_coord }
      end
    end
  end

  describe "#key_for" do
    [
      [Coord.new(0, 2), 'A'],
      [Coord.new(0, 1), '^'],
      [Coord.new(1, 0), '<'],
      [Coord.new(1, 1), 'v'],
      [Coord.new(1, 2), '>'],
    ].each do |coord, expected_key|
      context "with coord #{coord}" do
        subject { keypad.key_for(coord) }
        it { is_expected.to eq expected_key }
      end
    end
  end
end