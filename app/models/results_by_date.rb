# frozen_string_literal: true

class ResultsByDate
  def self.yearly_results
    ps_yearly = PokerSession.group_by_year(:start_time, series: false).sum('cashout - buyin')
    hh_yearly = HandHistory.joins(:poker_session).group_by_year(:start_time, series: false).sum(:result)

    PokerSession.iterable_years.index_with do |year|
      {
        session: ps_yearly.select { |k, _| k.year == year }.values.first,
        vpip:    hh_yearly.select { |k, _| k.year == year }.values.first
      }
    end
  end

  def self.monthly_results
    ps_monthly = PokerSession.group_by_month(:start_time, series: false).sum('cashout - buyin')
    hh_monthly = HandHistory.joins(:poker_session).group_by_month(:start_time, series: false).sum(:result)

    PokerSession.iterable_months.index_with do |d|
      {
        session: ps_monthly.select { |k, _| k.same_month?(d) }.values.first,
        vpip:    hh_monthly.select { |k, _| k.same_month?(d) }.values.first
      }
    end
  end
end
