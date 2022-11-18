# frozen_string_literal: true

RSpec.describe TableSize do
  it { is_expected.to validate_uniqueness_of(:table_size) }
  it { is_expected.to validate_uniqueness_of(:description) }

  describe 'TABLE_SIZE_ORDER' do
    it 'matches the proper order for table sizes' do
      expect(described_class::TABLE_SIZE_ORDER).to eq(
        ['10/9/8 handed', '7 handed', '6 handed', '5 handed', '4 handed', '3 handed', 'Heads Up']
      )
    end
  end

  describe '.custom_order' do
    it 'orders the results by TABLE_SIZE_ORDER' do
      expect(described_class.custom_order.pluck(:description)).to eq(described_class::TABLE_SIZE_ORDER)
    end
  end

  describe '#to_s' do
    subject { ts.to_s }

    let(:ts) { build(:table_size) }

    it { is_expected.to eq(ts.description) }
  end

  describe '.cached' do
    before do
      described_class.cached
    end

    let(:expected) do
      described_class::TABLE_SIZE_ORDER.map do |ts|
        [described_class.find_by(description: ts).id, ts]
      end
    end

    it 'returns a hash of the TableSize ids and descriptions' do
      expect(described_class.cached).to eq(expected)
    end

    it 'memoizes the result' do
      allow(described_class).to receive(:custom_order).and_call_original
      expect(described_class).to have_received(:custom_order).exactly(0).times
      2.times { described_class.cached }
    end
  end
end
