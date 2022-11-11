RSpec.describe Position do
  subject { build :position }

  describe 'POSITION_ORDER' do
    it 'matches hte proper order for positions' do
      expect(Position::POSITION_ORDER).to eq(['SB', 'BB', 'UTG', 'UTG1', 'MP', 'LJ', 'HJ', 'CO', 'BU', 'STRADDLE', 'UTG2'])
    end
  end

  describe '#to_s' do
    it 'returns the position field' do
      expect(subject.to_s).to eq(subject.position)
    end
  end

  describe '.cached' do
    subject! { create :position }

    it 'returns a JSON string of the Position names' do
      expect(Position.cached).to eq([
        {
          value: subject.position,
          label: subject.position
        }
      ].to_json)
    end
  end
end
