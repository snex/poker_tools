class ResultsByDate
  def initialize
    ps_yearly = PokerSession.group_by_year('start_time').sum('cashout - buyin')
    ps_monthly = PokerSession.group_by_month('start_time').sum('cashout - buyin')
    hh_yearly = HandHistory.joins(:poker_session).group_by_year('start_time').sum(:result)
    hh_monthly = HandHistory.joins(:poker_session).group_by_month('start_time').sum(:result)

    @results = {}
    @results[:yearly] = {}
    @results[:monthly] = {}
    ps_yearly.keys.each do |year|
      @results[:yearly][year] = {}
    end
    hh_yearly.keys.each do |year|
      @results[:yearly][year] = {}
    end
    ps_monthly.keys.each do |month|
      @results[:monthly][month] = {}
    end
    hh_monthly.keys.each do |month|
      @results[:monthly][month] = {}
    end

    ps_yearly.each do |year, result|
      @results[:yearly][year][:session] = result
    end
    hh_yearly.each do |year, result|
      @results[:yearly][year][:vpip] = result
    end

    ps_monthly.each do |month, result|
      @results[:monthly][month][:session] = result
    end
    hh_monthly.each do |month, result|
      @results[:monthly][month][:vpip] = result
    end
  end

  def yearly_results
    @results[:yearly].sort { |a,b| b <=> a }
  end

  def monthly_results
    @results[:monthly].sort { |a,b| b <=> a }
  end
end
