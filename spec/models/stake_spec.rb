RSpec.describe Stake do
  subject { build :stake }

  describe :before_save do
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

    it 'returns a JSON string of the Stake stakes' do
      expect(Stake.cached).to eq([
        {
          value: subject.stake,
          label: subject.stake
        }
      ].to_json)
    end
  end
end
