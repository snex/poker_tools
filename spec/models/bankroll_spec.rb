# frozen_string_literal: true

RSpec.describe Bankroll do
  subject(:b) { described_class.new }

  let!(:bt1) { create(:bankroll_transaction, amount: 100, date: Time.zone.today - 1.day) }
  let!(:bt2) { create(:bankroll_transaction, amount: 200, date: Time.zone.today) }
  let!(:ps) { create(:poker_session, buyin: 500, cashout: 1000) }

  describe '.new' do
    it 'sets @bankroll_transactions' do
      expect(b.bankroll_transactions).to eq([bt2, bt1])
    end

    it 'sets @poker_sessions' do
      expect(b.poker_sessions).to eq([ps])
    end
  end

  describe '#total_amount' do
    subject { described_class.new.total_amount }

    it { is_expected.to eq(800) }
  end
end
