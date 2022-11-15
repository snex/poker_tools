RSpec.describe TableSize do
  subject { build :table_size }

  it { should validate_uniqueness_of(:table_size) }
  it { should validate_uniqueness_of(:description) }

  describe 'TABLE_SIZE_ORDER' do
    it 'matches the proper order for table sizes' do
      expect(described_class::TABLE_SIZE_ORDER).to eq ['10/9/8 handed', '7 handed', '6 handed', '5 handed', '4 handed', '3 handed']
    end
  end

  describe '#to_s' do
    it 'returns the description field' do
      expect(subject.to_s).to eq(subject.description)
    end
  end

  describe '.cached' do
    let(:ordered) { described_class.order(described_class::TABLE_SIZE_ORDER.to_custom_sql_order(:description)) }
    let!(:expected) { described_class.order(described_class::TABLE_SIZE_ORDER.to_custom_sql_order(:description)).pluck(:id, :description) }

    it 'returns a hash of the TableSize ids and descriptions' do
      expect(described_class.cached).to eq(expected)
    end

    it 'memoizes the result' do
      expect(described_class).to receive(:order).exactly(0).times
      2.times { described_class.cached }
    end
  end
end
