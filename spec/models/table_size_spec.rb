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
    it 'returns a class-memoized JSON string of the BetSize descriptions' do
      expect(described_class).to receive(:pluck).with(:description).once.and_call_original
      expect(described_class.cached).to eq(described_class.all.map { |t| { value: t.description, label: t.description } }.to_json)
      2.times { described_class.cached }
    end

    it 'memoizes the result' do
    end
  end
end
