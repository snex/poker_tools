RSpec.describe Position do
  describe 'POSITION_ORDER' do
    it 'matches hte proper order for positions' do
      expect(Position::POSITION_ORDER).to eq(['SB', 'BB', 'UTG', 'UTG1', 'MP', 'LJ', 'HJ', 'CO', 'BU', 'STRADDLE', 'UTG2'])
    end
  end

  describe '#to_s' do
    let(:position) { build :position }

    it 'returns the position field' do
      expect(position.to_s).to eq(position.position)
    end
  end

  describe '.cached' do
    let!(:position) { create :position }

    it 'returns a JSON string of the Position names' do
      expect(Position.cached).to eq([
        {
          value: position.position,
          label: position.position
        }
      ].to_json)
    end
  end
end
