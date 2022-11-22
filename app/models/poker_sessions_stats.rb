# frozen_string_literal: true

module PokerSessionsStats
  def results(group_by = :all, poker_sessions = all)
    return poker_sessions.sum('cashout - buyin') if group_by == :all

    poker_sessions.send("group_by_#{group_by}", :start_time, series: false).sum('cashout - buyin').values
  end

  def duration(group_by = :all, poker_sessions = all)
    return poker_sessions.sum('end_time - start_time') if group_by == :all

    poker_sessions.send("group_by_#{group_by}", :start_time, series: false).sum('end_time - start_time').values
  end

  def hourly(poker_sessions = all)
    (results(:all, poker_sessions) / ((duration(:all, poker_sessions).to_f / 3600))).round(2)
  end

  def pct_won(group_by = :all, poker_sessions = all)
    if group_by == :all
      (poker_sessions.where('(cashout - buyin) > 0').count / poker_sessions.count.to_f).round(2)
    else
      res_arr = results(group_by, poker_sessions)
      (res_arr.select(&:positive?).count / res_arr.count.to_f).round(2)
    end
  end

  def best(group_by = :all, poker_sessions = all)
    extreme(:maximum, group_by, poker_sessions)
  end

  def worst(group_by = :all, poker_sessions = all)
    extreme(:minimum, group_by, poker_sessions)
  end

  def avg_wins(group_by = :all, poker_sessions = all)
    avg_condition('(cashout - buyin) > 0', group_by, poker_sessions)
  end

  def avg_wins_median(group_by = :all, poker_sessions = all)
    avg_median_condition('(cashout - buyin) > 0', group_by, poker_sessions)
  end

  def avg_losses(group_by = :all, poker_sessions = all)
    avg_condition('(cashout - buyin) < 0', group_by, poker_sessions)
  end

  def avg_losses_median(group_by = :all, poker_sessions = all)
    avg_median_condition('(cashout - buyin) < 0', group_by, poker_sessions)
  end

  def avg(group_by = :all, poker_sessions = all)
    avg_condition(nil, group_by, poker_sessions)
  end

  def avg_median(group_by = :all, poker_sessions = all)
    avg_median_condition(nil, group_by, poker_sessions)
  end

  def longest_win_streak(group_by = :all, poker_sessions = all)
    longest_streak_condition(:>, group_by, poker_sessions)
  end

  def longest_loss_streak(group_by = :all, poker_sessions = all)
    longest_streak_condition(:<, group_by, poker_sessions)
  end

  def hands_dealt(poker_sessions = all)
    poker_sessions.sum(:hands_dealt)
  end

  def hands_played(poker_sessions = all)
    HandHistory.with_poker_sessions(poker_sessions).count
  end

  def saw_flop(poker_sessions = all)
    HandHistory.with_poker_sessions(poker_sessions).saw_flop.count
  end

  def wtsd(poker_sessions = all)
    HandHistory.with_poker_sessions(poker_sessions).showdown.count
  end

  def wmsd(poker_sessions = all)
    HandHistory.with_poker_sessions(poker_sessions).won.showdown.count
  end

  def vpip(poker_sessions = all)
    # exclude sessions where we have hands played but did not record hands_dealt
    # in order to avoid infinity vpips
    hands_played_calc = poker_sessions.where.not(hands_dealt: nil)
    (hands_played(hands_played_calc) / hands_dealt(poker_sessions).to_f).round(2)
  end

  private

  def extreme(type, group_by = :all, poker_sessions = all)
    return poker_sessions.calculate(type, 'cashout - buyin') if group_by == :all

    results(group_by, poker_sessions).send(type, :itself)
  end

  def avg_condition(condition, group_by = :all, poker_sessions = all)
    return poker_sessions.where(condition).average('cashout - buyin').round(2) if group_by == :all

    results(group_by, poker_sessions.where(condition)).average.round(2)
  end

  def avg_median_condition(condition, group_by = :all, poker_sessions = all)
    if group_by == :all
      DescriptiveStatistics
        .median(poker_sessions.where(condition)
        .pluck(Arel.sql('cashout - buyin')))
        .to_f
        .round(2)
    else
      DescriptiveStatistics.median(results(group_by, poker_sessions.where(condition))).to_f.round(2)
    end
  end

  def longest_streak_condition(condition, group_by = :all, poker_sessions = all)
    return poker_sessions.pluck(Arel.sql('cashout - buyin')).longest_streak(0, condition) if group_by == :all

    results(group_by, poker_sessions).longest_streak(0, condition)
  end
end
