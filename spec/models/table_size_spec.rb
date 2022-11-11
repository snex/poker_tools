RSpec.describe TableSize do
  subject { build :table_size }

  describe 'TABLE_SIZE_ORDER' do
    it 'matches the proper order for table sizes' do
      expect(TableSize::TABLE_SIZE_ORDER).to eq ['10/9/8 handed', '7 handed', '6 handed', '5 handed', '4 handed', '3 handed']
    end
  end

  describe '#to_s' do
    it 'returns the description field' do
      expect(subject.to_s).to eq(subject.description)
    end
  end

  describe '.cached' do
    subject! { create :table_size }

    it 'returns a JSON string of the BetSize descriptions' do
      expect(TableSize.cached).to eq([
        {
          value: subject.description,
          label: subject.description
        }
      ].to_json)
    end
  end
end
