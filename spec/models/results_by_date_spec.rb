# frozen_string_literal: true

RSpec.describe ResultsByDate do
  subject(:rbd) { described_class.new }

  let(:hh) { class_double(HandHistory) }
  let(:ps) { class_double(PokerSession) }

  describe '#yearly_results' do
    it 'lists the yearly results sorted by year descending' do
      allow(HandHistory).to receive(:joins).with(:poker_session).and_return(hh, hh)
      allow(hh).to receive(:group_by_year).with('start_time').and_return(hh)
      allow(hh).to receive(:sum).with(:result).and_return(
        {
          2020 => 500,
          2021 => 1100
        }
      )
      allow(hh).to receive(:group_by_month).and_return(hh)
      allow(PokerSession).to receive(:group_by_year).with('start_time').and_return(ps)
      allow(ps).to receive(:sum).with('cashout - buyin').and_return(
        {
          2021 => 1000,
          2022 => 2000
        }
      )
      expect(rbd.yearly_results).to eq(
        [
          [
            2022,
            { session: 2000 }
          ],
          [
            2021,
            { session: 1000, vpip: 1100 }
          ],
          [
            2020,
            { vpip: 500 }
          ]
        ]
      )
    end
  end

  describe '#monthly_results' do
    it 'lists the monthly results sorted by year and month descending' do
      allow(HandHistory).to receive(:joins).with(:poker_session).and_return(hh, hh)
      allow(hh).to receive(:group_by_year).with('start_time').and_return(hh)
      allow(hh).to receive(:sum).with(:result).and_return({})
      allow(hh).to receive(:group_by_month).and_return(hh)
      allow(hh).to receive(:sum).with(:result).and_return(
        {
          Date.parse('2020-01-01') => 500,
          Date.parse('2020-02-01') => 1100,
          Date.parse('2021-01-01') => 1500
        }
      )
      allow(PokerSession).to receive(:group_by_month).with('start_time').and_return(ps)
      allow(ps).to receive(:sum).with('cashout - buyin').and_return(
        {
          Date.parse('2020-03-01') => 600,
          Date.parse('2021-01-01') => 1200,
          Date.parse('2021-02-01') => 2000
        }
      )
      expect(rbd.monthly_results).to eq(
        [
          [
            Date.parse('2021-02-01'),
            { session: 2000 }
          ],
          [
            Date.parse('2021-01-01'),
            { session: 1200, vpip: 1500 }
          ],
          [
            Date.parse('2020-03-01'),
            { session: 600 }
          ],
          [
            Date.parse('2020-02-01'),
            { vpip: 1100 }
          ],
          [
            Date.parse('2020-01-01'),
            { vpip: 500 }
          ]
        ]
      )
    end
  end
end
