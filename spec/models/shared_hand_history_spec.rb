# frozen_string_literal: true

RSpec.describe SharedHandHistory do
  it { is_expected.to belong_to(:hand_history) }

  describe 'validations' do
    before { create(:shared_hand_history, uuid: 'abc123') }

    it { is_expected.to validate_presence_of(:expires_at) }
    it { is_expected.to validate_uniqueness_of(:uuid) }
  end

  describe 'before_validation hook' do
    subject(:shh) { build(:shared_hand_history) }

    before { allow(SecureRandom).to receive(:hex).with(3).and_return('abc123') }

    it 'saves a UUID' do
      expect { shh.save }.to change(shh, :uuid).from(nil).to('abc123')
    end
  end

  describe '.expired' do
    subject { described_class.expired }

    let!(:shh) { create(:shared_hand_history, expires_at: 1.hour.ago) }

    before { create(:shared_hand_history, expires_at: 1.hour.from_now) }

    it { is_expected.to contain_exactly(shh) }
  end

  describe '.destroy_expired' do
    let!(:shh1) { create(:shared_hand_history, expires_at: 1.hour.ago) }
    let!(:shh2) { create(:shared_hand_history, expires_at: 1.hour.from_now) }

    it 'deletes expired SharedHandHistory objects' do
      expect { described_class.destroy_expired }.to change(described_class, :all).from([shh1, shh2]).to([shh2])
    end
  end
end
