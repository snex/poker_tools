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
    it 'returns a class-memoized JSON string of the described_class names' do
      expect(described_class).to receive(:pluck).with(:position).once.and_call_original
      expect(described_class.cached).to eq(described_class.all.map { |p| { value: p.position, label: p.position } }.to_json)
      2.times { described_class.cached }
    end
  end
end
