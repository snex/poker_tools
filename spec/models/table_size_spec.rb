RSpec.describe TableSize do
  describe 'TABLE_SIZE_ORDER' do
    it 'matches the proper order for table sizes' do
      expect(TableSize::TABLE_SIZE_ORDER).to eq ['10/9/8 handed', '7 handed', '6 handed', '5 handed', '4 handed', '3 handed']
    end
  end

  describe '#to_s' do
    let(:table_size) { build :table_size }

    it 'returns the description field' do
      expect(table_size.to_s).to eq(table_size.description)
    end
  end

  describe '.cached' do
    let!(:table_size) { create :table_size }

    it 'returns a JSON string of the BetSize descriptions' do
      expect(TableSize.cached).to eq([
        {
          value: table_size.description,
          label: table_size.description
        }
      ].to_json)
    end
  end
end
