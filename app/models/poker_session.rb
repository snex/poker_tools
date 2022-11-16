# frozen_string_literal: true

class PokerSession < ApplicationRecord
  belongs_to :stake
  belongs_to :bet_structure
  belongs_to :poker_variant
  has_many :hand_histories, dependent: :restrict_with_exception

  def game_type
    "#{stake.stake} #{bet_structure.abbreviation}#{poker_variant.abbreviation}"
  end

  def result
    @result ||= cashout - buyin
  end

  def duration
    @duration ||= (end_time - start_time)
  end

  def hourly
    @hourly ||= (result.to_f / (duration.to_f / 3600)).round(2)
  end

  def hands_played
    @hands_played ||= hand_histories.count
  end

  def saw_flop
    @saw_flop ||= hand_histories.where.not(flop: nil).count
  end

  def wtsd
    @wtsd ||= hand_histories.where(showdown: true).count
  end

  def wmsd
    @wmsd ||= hand_histories.where(showdown: true).where('result >= 0').count
  end

  def vpip
    @vpip ||= (hands_played / hands_dealt.to_f).round(2)
  end

  def self.import(date, data)
    transaction do
      session_lines = data.split("\n")
      stake = bs = pv = start_time = end_time = buyin = cashout = hands_dealt = nil

      session_lines.each do |sl|
        sl.strip!

        case sl
        when /^session .*/i
          game_type = sl.match(/^session (.*)$/i)[1]
          gt = GameType.new(game_type)
          stake = gt.stake
          bs = gt.bet_structure
          pv = gt.poker_variant
        when /^start: .*/i
          start_time = ActiveSupport::TimeZone[Time.zone.name].parse("#{date} #{sl.match(/^start: (.*)$/i)[1]}")
        when /^end: .*/i
          end_time = ActiveSupport::TimeZone[Time.zone.name].parse("#{date} #{sl.match(/^end: (.*)$/i)[1]}")
        when /^in: .*/i
          buyin = sl.match(/^in: (.*)$/i)[1].to_i
        when /^out: .*/i
          cashout = sl.match(/^out: (.*)$/i)[1].to_i
        when /^hands: .*/i
          hands_dealt = sl.match(/^hands: (.*)$/i)[1].to_i
        end
      end

      # this can happen if the session goes beyond midnight
      end_time += 1.day if end_time < start_time

      create!(
        start_time:    start_time,
        end_time:      end_time,
        buyin:         buyin,
        cashout:       cashout,
        hands_dealt:   hands_dealt,
        stake:         stake,
        bet_structure: bs,
        poker_variant: pv
      )
    end
  end

  def self.results(poker_sessions = all)
    poker_sessions.sum('cashout - buyin')
  end

  def self.daily_results(poker_sessions = all)
    poker_sessions.group_by_day(:start_time, series: false).sum('cashout - buyin').values
  end

  def self.weekly_results(poker_sessions = all)
    poker_sessions.group_by_week(:start_time, series: false).sum('cashout - buyin').values
  end

  def self.monthly_results(poker_sessions = all)
    poker_sessions.group_by_month(:start_time, series: false).sum('cashout - buyin').values
  end

  def self.yearly_results(poker_sessions = all)
    poker_sessions.group_by_year(:start_time, series: false).sum('cashout - buyin').values
  end

  def self.duration(poker_sessions = all)
    poker_sessions.sum('end_time - start_time')
  end

  def self.daily_durations(poker_sessions = all)
    poker_sessions.group_by_day(:start_time, series: false).sum('end_time - start_time').values
  end

  def self.hourly(poker_sessions = all)
    (results(poker_sessions).to_f / ((duration(poker_sessions).to_f / 3600))).round(2)
  end

  def self.pct_won(poker_sessions = all)
    (poker_sessions.where('(cashout - buyin) > 0').count.to_f / poker_sessions.count).round(2)
  end

  def self.daily_pct_won(poker_sessions = all)
    res_arr = daily_results(poker_sessions)
    (res_arr.select(&:positive?).count / res_arr.count.to_f).round(2)
  end

  def self.weekly_pct_won(poker_sessions = all)
    res_arr = weekly_results(poker_sessions)
    (res_arr.select(&:positive?).count / res_arr.count.to_f).round(2)
  end

  def self.monthly_pct_won(poker_sessions = all)
    res_arr = monthly_results(poker_sessions)
    (res_arr.select(&:positive?).count / res_arr.count.to_f).round(2)
  end

  def self.yearly_pct_won(poker_sessions = all)
    res_arr = yearly_results(poker_sessions)
    (res_arr.select(&:positive?).count / res_arr.count.to_f).round(2)
  end

  def self.best(poker_sessions = all)
    poker_sessions.maximum('cashout - buyin')
  end

  def self.daily_best(poker_sessions = all)
    daily_results(poker_sessions).max
  end

  def self.weekly_best(poker_sessions = all)
    weekly_results(poker_sessions).max
  end

  def self.monthly_best(poker_sessions = all)
    monthly_results(poker_sessions).max
  end

  def self.yearly_best(poker_sessions = all)
    yearly_results(poker_sessions).max
  end

  def self.worst(poker_sessions = all)
    poker_sessions.minimum('cashout - buyin')
  end

  def self.daily_worst(poker_sessions = all)
    daily_results(poker_sessions).min
  end

  def self.weekly_worst(poker_sessions = all)
    weekly_results(poker_sessions).min
  end

  def self.monthly_worst(poker_sessions = all)
    monthly_results(poker_sessions).min
  end

  def self.yearly_worst(poker_sessions = all)
    yearly_results(poker_sessions).min
  end

  def self.avg_wins(poker_sessions = all)
    poker_sessions.where('(cashout - buyin) > 0').average('(cashout - buyin)').round(2)
  end

  def self.avg_wins_median(poker_sessions = all)
    DescriptiveStatistics
      .median(poker_sessions.where('(cashout - buyin) > 0')
      .pluck(Arel.sql('(cashout - buyin)')))
      .round(2)
  end

  def self.daily_avg_wins(poker_sessions = all)
    daily_results(poker_sessions).select(&:positive?).average.round(2)
  end

  def self.daily_avg_wins_median(poker_sessions = all)
    DescriptiveStatistics.median(daily_results(poker_sessions).select(&:positive?)).round(2)
  end

  def self.weekly_avg_wins(poker_sessions = all)
    weekly_results(poker_sessions).select(&:positive?).average.round(2)
  end

  def self.weekly_avg_wins_median(poker_sessions = all)
    DescriptiveStatistics.median(weekly_results(poker_sessions).select(&:positive?)).round(2)
  end

  def self.monthly_avg_wins(poker_sessions = all)
    monthly_results(poker_sessions).select(&:positive?).average.round(2)
  end

  def self.monthly_avg_wins_median(poker_sessions = all)
    DescriptiveStatistics.median(monthly_results(poker_sessions).select(&:positive?)).round(2)
  end

  def self.yearly_avg_wins(poker_sessions = all)
    yearly_results(poker_sessions).select(&:positive?).average.round(2)
  end

  def self.yearly_avg_wins_median(poker_sessions = all)
    DescriptiveStatistics.median(yearly_results(poker_sessions).select(&:positive?)).round(2)
  end

  def self.avg_losses(poker_sessions = all)
    poker_sessions.where('(cashout - buyin) < 0').average('(cashout - buyin)').round(2)
  end

  def self.avg_losses_median(poker_sessions = all)
    DescriptiveStatistics
      .median(poker_sessions.where('(cashout - buyin) < 0')
      .pluck(Arel.sql('(cashout - buyin)')))
      .round(2)
  end

  def self.daily_avg_losses(poker_sessions = all)
    daily_results(poker_sessions).select(&:negative?).average.round(2)
  end

  def self.daily_avg_losses_median(poker_sessions = all)
    DescriptiveStatistics.median(daily_results(poker_sessions).select(&:negative?)).round(2)
  end

  def self.weekly_avg_losses(poker_sessions = all)
    weekly_results(poker_sessions).select(&:negative?).average.round(2)
  end

  def self.weekly_avg_losses_median(poker_sessions = all)
    DescriptiveStatistics.median(weekly_results(poker_sessions).select(&:negative?)).round(2)
  end

  def self.monthly_avg_losses(poker_sessions = all)
    monthly_results(poker_sessions).select(&:negative?).average.round(2)
  end

  def self.monthly_avg_losses_median(poker_sessions = all)
    DescriptiveStatistics.median(monthly_results(poker_sessions).select(&:negative?)).round(2)
  end

  def self.yearly_avg_losses(poker_sessions = all)
    yearly_results(poker_sessions).select(&:negative?).average.round(2)
  end

  def self.yearly_avg_losses_median(poker_sessions = all)
    DescriptiveStatistics.median(yearly_results(poker_sessions).select(&:negative?)).round(2)
  end

  def self.avg(poker_sessions = all)
    poker_sessions.average('(cashout - buyin)').round(2)
  end

  def self.avg_median(poker_sessions = all)
    DescriptiveStatistics.median(poker_sessions.pluck(Arel.sql('(cashout - buyin)'))).round(2)
  end

  def self.daily_avg(poker_sessions = all)
    daily_results(poker_sessions).average.round(2)
  end

  def self.daily_avg_median(poker_sessions = all)
    DescriptiveStatistics.median(daily_results(poker_sessions)).round(2)
  end

  def self.weekly_avg(poker_sessions = all)
    weekly_results(poker_sessions).average.round(2)
  end

  def self.weekly_avg_median(poker_sessions = all)
    DescriptiveStatistics.median(weekly_results(poker_sessions)).round(2)
  end

  def self.monthly_avg(poker_sessions = all)
    monthly_results(poker_sessions).average.round(2)
  end

  def self.monthly_avg_median(poker_sessions = all)
    DescriptiveStatistics.median(monthly_results(poker_sessions)).round(2)
  end

  def self.yearly_avg(poker_sessions = all)
    yearly_results(poker_sessions).average.round(2)
  end

  def self.yearly_avg_median(poker_sessions = all)
    DescriptiveStatistics.median(yearly_results(poker_sessions)).round(2)
  end

  def self.longest_win_streak(poker_sessions = all)
    poker_sessions.pluck(Arel.sql('cashout - buyin')).longest_streak(0, :>)
  end

  def self.daily_longest_win_streak(poker_sessions = all)
    daily_results(poker_sessions).longest_streak(0, :>)
  end

  def self.weekly_longest_win_streak(poker_sessions = all)
    weekly_results(poker_sessions).longest_streak(0, :>)
  end

  def self.monthly_longest_win_streak(poker_sessions = all)
    monthly_results(poker_sessions).longest_streak(0, :>)
  end

  def self.yearly_longest_win_streak(poker_sessions = all)
    yearly_results(poker_sessions).longest_streak(0, :>)
  end

  def self.longest_loss_streak(poker_sessions = all)
    poker_sessions.pluck(Arel.sql('cashout - buyin')).longest_streak(0, :<)
  end

  def self.daily_longest_loss_streak(poker_sessions = all)
    daily_results(poker_sessions).longest_streak(0, :<)
  end

  def self.weekly_longest_loss_streak(poker_sessions = all)
    weekly_results(poker_sessions).longest_streak(0, :<)
  end

  def self.monthly_longest_loss_streak(poker_sessions = all)
    monthly_results(poker_sessions).longest_streak(0, :<)
  end

  def self.yearly_longest_loss_streak(poker_sessions = all)
    yearly_results(poker_sessions).longest_streak(0, :<)
  end

  def self.hands_dealt(poker_sessions = all)
    poker_sessions.sum(:hands_dealt)
  end

  def self.hands_played(poker_sessions = all)
    poker_sessions.joins(:hand_histories).count('hand_histories.id')
  end

  def self.saw_flop(poker_sessions = all)
    poker_sessions.joins(:hand_histories).where.not(hand_histories: { flop: nil }).count('hand_histories.id')
  end

  def self.wtsd(poker_sessions = all)
    poker_sessions.joins(:hand_histories).where(hand_histories: { showdown: true }).count('hand_histories.id')
  end

  def self.wmsd(poker_sessions = all)
    poker_sessions
      .joins(:hand_histories)
      .where(hand_histories: { showdown: true })
      .where('hand_histories.result >= 0')
      .count('hand_histories.id')
  end

  def self.vpip(poker_sessions = all)
    (hands_played(poker_sessions.where.not(hands_dealt: nil)) / hands_dealt(poker_sessions).to_f).round(2)
  end
end
