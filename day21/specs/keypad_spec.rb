require './keypad'

RSpec.describe Keypad do
  subject(:keypad) { Keypad.new nil, [] }

  describe '#coalesce' do
    subject { keypad.coalesce sequences }

    context 'with no sequences' do
      let(:sequences) { [] }
      let(:expected_sequences) { [] }

      it { is_expected.to eq expected_sequences }
    end

    context 'with only one level of sequences' do
      let(:sequences) do
        [
          ['^^>A'.split(''), '>^^A'.split('')],
        ]
      end

      let(:expected_sequences) do
        [
          '^^>A'.split(''),
          '>^^A'.split(''),
        ]
      end

      it { is_expected.to eq expected_sequences }
    end

    context 'for code 029A' do
      let(:sequences) do
        [
          ['<A'.split('')],
          ['^A'.split('')],
          ['^^>A'.split(''), '>^^A'.split('')],
          ['vvvA'.split('')],
        ]
      end

      let(:expected_sequences) do
        [
          '<A^A^^>AvvvA'.split(''),
          '<A^A>^^AvvvA'.split(''),
        ]
      end

      it { is_expected.to eq expected_sequences }
    end

    context 'for cross-product of sequences' do
      let(:sequences) do
        [
          ['^^>A'.split(''), '>^^A'.split('')],
          ['^^>>A'.split(''), '>>^^A'.split('')],
        ]
      end

      let(:expected_sequences) do
        [
          '^^>A^^>>A'.split(''),
          '^^>A>>^^A'.split(''),
          '>^^A^^>>A'.split(''),
          '>^^A>>^^A'.split(''),
        ]
      end

      it { is_expected.to eq expected_sequences }
    end
  end
end
