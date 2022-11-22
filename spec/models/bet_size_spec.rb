# frozen_string_literal: true

RSpec.describe BetSize do
  it { is_expected.to validate_uniqueness_of(:bet_size) }
  it { is_expected.to validate_uniqueness_of(:description) }
  it { is_expected.to validate_uniqueness_of(:color) }

  describe 'BET_SIZE_ORDER' do
    it 'matches the proper order for bet sizings' do
      expect(described_class::BET_SIZE_ORDER).to eq %w[limp 2b 3b 4b 5b 6b]
    end
  end

  describe '#custom_order' do
    it 'orders the results by BET_SIZE_ORDER' do
      expect(described_class.custom_order.pluck(:description)).to eq(described_class::BET_SIZE_ORDER)
    end
  end

  describe '#to_s' do
    subject { bs.to_s }

    let(:bs) { build(:bet_size) }

    it { is_expected.to eq(bs.description) }
  end

  describe '.cached' do
    before do
      described_class.cached
    end

    let(:expected) do
      described_class::BET_SIZE_ORDER.map do |bs|
        [described_class.find_by(description: bs).id, bs]
      end
    end

    it 'returns a hash of the BetSize ids and descriptions' do
      expect(described_class.cached).to eq(expected)
    end

    it 'memoizes the result' do
      allow(described_class).to receive(:custom_order).and_call_original
      expect(described_class).to have_received(:custom_order).exactly(0).times
      2.times { described_class.cached }
    end
  end
end
