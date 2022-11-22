# frozen_string_literal: true

RSpec.describe ResultsByDate do
  before do
    create(:poker_session, start_time: DateTime.parse('2020-12-25 16:02 PST'), buyin: 500, cashout: 1000)
    ps = create(:poker_session, start_time: DateTime.parse('2021-02-01 05:00 PST'), buyin: 1000, cashout: 2100)
    create(:hand_history, poker_session: ps, result: 1000)
  end

  describe '#yearly_results' do
    subject { described_class.yearly_results }

    let(:expected) do
      {
        2021 => { session: 1100, vpip: 1000 },
        2020 => { session: 500, vpip: nil }
      }
    end

    it { is_expected.to eq(expected) }
  end

  describe '#monthly_results' do
    subject { described_class.monthly_results }

    let(:expected) do
      {
        Date.parse('2021-02-01') => { session: 1100, vpip: 1000 },
        Date.parse('2021-01-01') => { session: nil, vpip: nil },
        Date.parse('2020-12-01') => { session: 500, vpip: nil }
      }
    end

    it { is_expected.to eq(expected) }
  end
end
