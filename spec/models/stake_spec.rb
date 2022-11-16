# frozen_string_literal: true

RSpec.describe Stake do
  subject(:s) { build(:stake) }

  describe 'before_save hook' do
    context 'with bad value passed' do
      subject(:s) { build(:stake, stake: 'a/5') }

      it 'fails to save with an error' do
        expect { s.save }.to raise_error(ArgumentError, /invalid value for Integer\(\): "a"/)
      end
    end

    it 'saves to stakes_array' do
      expected = s.stake.split('/').map(&:to_i).reverse
      expect { s.save }.to change(s, :stakes_array).from(nil).to(expected)
    end
  end

  describe '#to_s' do
    it 'returns the stake field' do
      expect(s.to_s).to eq(s.stake)
    end
  end

  describe '.cached' do
    let!(:s1) { create(:stake, stake: '10/20') }
    let!(:s2) { create(:stake, stake: '5/10') }

    it 'returns a hash of the Stake ids and stakes' do
      expect(described_class.cached).to eq([[s2.id, '5/10'], [s1.id, '10/20']])
    end

    it 'does not memoize the result' do
      allow(described_class).to receive(:order).and_call_original
      2.times { described_class.cached }
      expect(described_class).to have_received(:order).with(:stakes_array).twice
    end
  end
end
