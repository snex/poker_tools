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
    let(:ordered) { described_class.order(described_class::BET_SIZE_ORDER.to_custom_sql_order(:description)) }
    let!(:expected) { described_class.order(described_class::BET_SIZE_ORDER.to_custom_sql_order(:description)).pluck(:id, :description) }

    it 'returns a hash of the BetSize ids and descriptions' do
      expect(described_class.cached).to eq(expected)
    end

    it 'memoizes the result' do
      expect(described_class).to receive(:order).exactly(0).times
      2.times { described_class.cached }
    end
  end
end
