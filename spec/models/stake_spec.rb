RSpec.describe Stake do
  describe :before_save do
    let(:stake) { build :stake }

    it 'saves to stakes_array' do
      expected = stake.stake.split('/').map(&:to_i).reverse
      expect { stake.save }.to change { stake.stakes_array }.from(nil).to(expected)
    end
  end

  describe '#to_s' do
    let(:stake) { build :stake }

    it 'returns the stake field' do
      expect(stake.to_s).to eq(stake.stake)
    end
  end

  describe '.cached' do
    let!(:stake) { create :stake }

    it 'returns a JSON string of the Stake stakes' do
      expect(Stake.cached).to eq([
        {
          value: stake.stake,
          label: stake.stake
        }
      ].to_json)
    end
  end
end
