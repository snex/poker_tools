RSpec.describe BetSize do
  describe 'BET_SIZE_ORDER' do
    it 'matches the proper order for bet sizings' do
      expect(BetSize::BET_SIZE_ORDER).to eq ['limp', '2b', '3b', '4b', '5b', '6b']
    end
  end

  describe '#to_s' do
    let(:bet_size) { build :bet_size }

    it 'returns the description field' do
      expect(bet_size.to_s).to eq(bet_size.description)
    end
  end

  describe '.cached' do
    let!(:bet_size) { create :bet_size }

    it 'returns a JSON string of the BetSize descriptions' do
      expect(BetSize.cached).to eq([
        {
          value: bet_size.description,
          label: bet_size.description
        }
      ].to_json)
    end
  end
end
