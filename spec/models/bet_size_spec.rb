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

  describe '#custom_order' do
    it 'orders the results by BET_SIZE_ORDER' do
      expect(described_class.custom_order.pluck(:description)).to eq(described_class::BET_SIZE_ORDER)
    end
  end

  describe '#to_s' do
    it 'returns the description field' do
      expect(subject.to_s).to eq(subject.description)
    end
  end

  describe '.cached' do
    let(:ordered) { described_class.custom_order }
    let!(:expected) { described_class.custom_order.pluck(:id, :description) }

    it 'returns a hash of the BetSize ids and descriptions' do
      expect(described_class.cached).to eq(expected)
    end

    it 'memoizes the result' do
      expect(described_class).to receive(:custom_order).exactly(0).times
      2.times { described_class.cached }
    end
  end
end
