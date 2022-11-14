RSpec.describe BetSize do
  subject { build :bet_size }

  it { should validate_uniqueness_of(:bet_size) }
  it { should validate_uniqueness_of(:description) }
  it { should validate_uniqueness_of(:color) }

  describe 'BET_SIZE_ORDER' do
    it 'matches the proper order for bet sizings' do
      expect(described_class::BET_SIZE_ORDER).to eq ['limp', '2b', '3b', '4b', '5b', '6b']
    end
  end

  describe '#to_s' do
    it 'returns the description field' do
      expect(subject.to_s).to eq(subject.description)
    end
  end

  describe '.cached' do
    it 'returns a class-memoized JSON string of the described_class descriptions' do
      expect(described_class).to receive(:pluck).with(:description).once.and_call_original
      expect(described_class.cached).to eq(described_class.all.map { |b| { value: b.description, label: b.description } }.to_json)
      2.times { described_class.cached }
    end
  end
end
