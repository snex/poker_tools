RSpec.describe BetSize do
  subject { build :bet_size }

  describe 'BET_SIZE_ORDER' do
    it 'matches the proper order for bet sizings' do
      expect(BetSize::BET_SIZE_ORDER).to eq ['limp', '2b', '3b', '4b', '5b', '6b']
    end
  end

  describe '#to_s' do
    it 'returns the description field' do
      expect(subject.to_s).to eq(subject.description)
    end
  end

  describe '.cached' do
    subject! { create :bet_size }

    it 'returns a JSON string of the BetSize descriptions' do
      expect(BetSize.cached).to eq([
        {
          value: subject.description,
          label: subject.description
        }
      ].to_json)
    end
  end
end
