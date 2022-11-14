RSpec.describe Stake do
  subject { build :stake }

  describe :before_save do
    context 'bad value passed' do
      subject { build :stake, stake: 'a/5' }

      it 'fails to save with an error' do
        expect { subject.save }.to raise_error(ArgumentError, /invalid value for Integer\(\): "a"/)
      end
    end

    it 'saves to stakes_array' do
      expected = subject.stake.split('/').map(&:to_i).reverse
      expect { subject.save }.to change { subject.stakes_array }.from(nil).to(expected)
    end
  end

  describe '#to_s' do
    it 'returns the stake field' do
      expect(subject.to_s).to eq(subject.stake)
    end
  end

  describe '.cached' do
    subject! { create :stake }

    it 'returns a class-memoized JSON string of the Stake stakes' do
      expect(described_class).to receive(:order).with(:stakes_array).once.and_call_original
      expect(described_class.cached).to eq([
        {
          value: subject.stake,
          label: subject.stake
        }
      ].to_json)
      2.times { described_class.cached }
    end
  end
end
