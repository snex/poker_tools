RSpec.describe Position do
  subject { build :position }

  it { should validate_uniqueness_of(:position) }

  describe 'POSITION_ORDER' do
    it 'matches hte proper order for positions' do
      expect(described_class::POSITION_ORDER).to eq(['SB', 'BB', 'UTG', 'UTG1', 'MP', 'LJ', 'HJ', 'CO', 'BU', 'STRADDLE', 'UTG2'])
    end
  end

  describe '#to_s' do
    it 'returns the position field' do
      expect(subject.to_s).to eq(subject.position)
    end
  end

  describe '.cached' do
    let(:ordered) { described_class.order(described_class::POSITION_ORDER.to_custom_sql_order(:position)) }
    let!(:expected) { described_class.order(described_class::POSITION_ORDER.to_custom_sql_order(:position)).pluck(:id, :position) }

    it 'returns a hash of the Position ids and position' do
      expect(described_class.cached).to eq(expected)
    end

    it 'memoizes the result' do
      expect(described_class).to receive(:order).exactly(0).times
      2.times { described_class.cached }
    end
  end
end
