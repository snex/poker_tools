require 'csv'

class PokerSession < ApplicationRecord
  belongs_to :stake
  belongs_to :bet_structure
  belongs_to :poker_variant
  has_many :hand_histories

  def game_type
    "#{stake.stake} #{bet_structure.abbreviation}#{poker_variant.abbreviation}"
  end

  def result
    @res ||= self.cashout - self.buyin
  end

  def duration
    @secs ||= (self.end_time - self.start_time).to_i
  end

  def hourly
    (result.to_f / (duration.to_f / 3600)).round(2)
  end

  def hands_played
    hand_histories.count
  end

  def saw_flop
    hand_histories.where.not(flop: nil).count
  end

  def wtsd
    hand_histories.where(showdown: true).count
  end

  def wmsd
    hand_histories.where(showdown: true).where('result >= 0').count
  end

  def vpip
    (hands_played.to_f / hands_dealt.to_f).round(2)
  end

  def self.result(poker_sessions = all)
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
    (result(poker_sessions).to_f / ((duration(poker_sessions).to_f / 3600))).round(2)
  end

  def self.pct_won(poker_sessions = all)
    (poker_sessions.where('(cashout - buyin) > 0').count.to_f / poker_sessions.count).round(2)
  end

  def self.daily_pct_won(poker_sessions = all)
    res_arr = daily_results(poker_sessions)
    (res_arr.select { |r| r > 0 }.count.to_f / res_arr.count.to_f).round(2)
  end

  def self.weekly_pct_won(poker_sessions = all)
    res_arr = weekly_results(poker_sessions)
    (res_arr.select { |r| r > 0 }.count.to_f / res_arr.count.to_f).round(2)
  end

  def self.monthly_pct_won(poker_sessions = all)
    res_arr = monthly_results(poker_sessions)
    (res_arr.select { |r| r > 0 }.count.to_f / res_arr.count.to_f).round(2)
  end

  def self.yearly_pct_won(poker_sessions = all)
    res_arr = yearly_results(poker_sessions)
    (res_arr.select { |r| r > 0 }.count.to_f / res_arr.count.to_f).round(2)
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
    DescriptiveStatistics.median(poker_sessions.where('(cashout - buyin) > 0').pluck(Arel.sql('(cashout - buyin)'))).round(2)
  end

  def self.daily_avg_wins(poker_sessions = all)
    daily_results(poker_sessions).select { |r| r > 0 }.average.round(2)
  end

  def self.daily_avg_wins_median(poker_sessions = all)
    DescriptiveStatistics.median(daily_results(poker_sessions).select { |r| r > 0 }).round(2)
  end

  def self.weekly_avg_wins(poker_sessions = all)
    weekly_results(poker_sessions).select { |r| r > 0 }.average.round(2)
  end

  def self.weekly_avg_wins_median(poker_sessions = all)
    DescriptiveStatistics.median(weekly_results(poker_sessions).select { |r| r > 0 }).round(2)
  end

  def self.monthly_avg_wins(poker_sessions = all)
    monthly_results(poker_sessions).select { |r| r > 0 }.average.round(2)
  end

  def self.monthly_avg_wins_median(poker_sessions = all)
    DescriptiveStatistics.median(monthly_results(poker_sessions).select { |r| r > 0 }).round(2)
  end

  def self.yearly_avg_wins(poker_sessions = all)
    yearly_results(poker_sessions).select { |r| r > 0 }.average.round(2)
  end

  def self.yearly_avg_wins_median(poker_sessions = all)
    DescriptiveStatistics.median(yearly_results(poker_sessions).select { |r| r > 0 }).round(2)
  end

  def self.avg_losses(poker_sessions = all)
    poker_sessions.where('(cashout - buyin) < 0').average('(cashout - buyin)').round(2)
  end

  def self.avg_losses_median(poker_sessions = all)
    DescriptiveStatistics.median(poker_sessions.where('(cashout - buyin) < 0').pluck(Arel.sql('(cashout - buyin)'))).round(2)
  end

  def self.daily_avg_losses(poker_sessions = all)
    daily_results(poker_sessions).select { |r| r < 0 }.average.round(2)
  end

  def self.daily_avg_losses_median(poker_sessions = all)
    DescriptiveStatistics.median(daily_results(poker_sessions).select { |r| r < 0 }).round(2)
  end

  def self.weekly_avg_losses(poker_sessions = all)
    weekly_results(poker_sessions).select { |r| r < 0 }.average.round(2)
  end

  def self.weekly_avg_losses_median(poker_sessions = all)
    DescriptiveStatistics.median(weekly_results(poker_sessions).select { |r| r < 0 }).round(2)
  end

  def self.monthly_avg_losses(poker_sessions = all)
    monthly_results(poker_sessions).select { |r| r < 0 }.average.round(2)
  end

  def self.monthly_avg_losses_median(poker_sessions = all)
    DescriptiveStatistics.median(monthly_results(poker_sessions).select { |r| r < 0 }).round(2)
  end

  def self.yearly_avg_losses(poker_sessions = all)
    yearly_results(poker_sessions).select { |r| r < 0 }.average.round(2)
  end

  def self.yearly_avg_losses_median(poker_sessions = all)
    DescriptiveStatistics.median(yearly_results(poker_sessions).select { |r| r < 0 }).to_f.round(2)
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
    daily_results.longest_streak(0, :>)
  end

  def self.weekly_longest_win_streak(poker_sessions = all)
    weekly_results.longest_streak(0, :>)
  end

  def self.monthly_longest_win_streak(poker_sessions = all)
    monthly_results.longest_streak(0, :>)
  end

  def self.yearly_longest_win_streak(poker_sessions = all)
    yearly_results.longest_streak(0, :>)
  end

  def self.longest_loss_streak(poker_sessions = all)
    poker_sessions.pluck(Arel.sql('cashout - buyin')).longest_streak(0, :<)
  end

  def self.daily_longest_loss_streak(poker_sessions = all)
    daily_results.longest_streak(0, :<)
  end

  def self.weekly_longest_loss_streak(poker_sessions = all)
    weekly_results.longest_streak(0, :<)
  end

  def self.monthly_longest_loss_streak(poker_sessions = all)
    monthly_results.longest_streak(0, :<)
  end

  def self.yearly_longest_loss_streak(poker_sessions = all)
    yearly_results.longest_streak(0, :<)
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
    poker_sessions.joins(:hand_histories).where(hand_histories: { showdown: true }).where('hand_histories.result >= 0').count('hand_histories.id')
  end

  def self.vpip(poker_sessions = all)
    (hands_played(poker_sessions.where.not(hands_dealt: nil)).to_f / hands_dealt(poker_sessions).to_f).round(2)
  end

  def self.import_csv(filename)
    transaction do
      CSV.foreach(filename, headers: true) do |csv|
        date = ActiveSupport::TimeZone[Time.zone.name].strptime(csv['Date'], '%Y-%m-%d')
        start_time = csv['Start Time']
        end_time = csv['End Time']
        game = csv['Game']
        stake_str, game_name = game.split(' ')
        stake = Stake.find_or_create_by(stake: stake_str)
        bs = BetStructure.find_by(name: 'No Limit')
        pv = PokerVariant.find_by(name: 'Texas Holdem')

        if start_time.blank? || end_time.blank?
          duration = csv['Duration']
          hrs, mins = duration.split(':').map(&:to_i)
          duration_mins = hrs * 60 + mins
          start_time = date.at_midnight
          end_time = start_time + duration_mins.minutes
        else
          start_time = "#{date.to_date.to_s} #{start_time}"
          end_time = "#{date.to_date.to_s} #{end_time}"
        end

        case game_name
        when 'BigO'
          bs = BetStructure.find_by(name: 'Pot Limit')
          pv = PokerVariant.find_by(name: 'BigO')
        end

        puts start_time
        PokerSession.create!(
          buyin:         csv['Buyin'].to_i,
          cashout:       csv['Cashout'].to_i,
          start_time:    start_time,
          end_time:      end_time,
          stake:         stake,
          bet_structure: bs,
          poker_variant: pv,
          hands_dealt:   csv['Hands Dealt'].to_i
        )
      end
    end
  end

  def self.import_xml(filename)
    xml = Nokogiri::XML(File.readlines(filename).join(''))

    transaction do
      xml.xpath('//sessions/cash').select do |c|
        c.attributes['bankroll'].value == 'Live'
      end.each do |c|
        attrs = c.attributes
        res_attrs = c.xpath('./results/result').first.attributes
        stake = "#{attrs['sb']}/#{attrs['bb']}"
        bs = case attrs['limit'].value
             when '0'
               BetStructure.find_by(name: 'No Limit')
             when '1'
               BetStructure.find_by(name: 'Pot Limit')
             when '2'
               BetStructure.find_by(name: 'Fixed Limit')
             else
               raise 'unknown limit'
             end
        pv = case attrs['variant'].value
             when 'OH|Omaha'
               PokerVariant.find_by(name: 'Omaha')
             when 'Texas Hold\'em|Texas Hold\'em'
               PokerVariant.find_by(name: 'Texas Holdem')
             when 'Mixed|Mixed'
               PokerVariant.find_by(name: 'Mix')
             when 'BigO|BigO'
               PokerVariant.find_by(name: 'BigO')
             when 'OH8|Omaha Hi-Low'
               PokerVariant.find_by(name: 'Omaha Hi-Lo')
             else
               raise 'unknown variant'
             end

        PokerSession.create!(
          buyin:         res_attrs['buyin'].value.to_i,
          cashout:       res_attrs['chipcount'].value.to_i,
          start_time:    DateTime.strptime(attrs['startdate'].value, '%m/%d/%y %H:%M:%S'),
          end_time:      DateTime.strptime(attrs['enddate'].value, '%m/%d/%y %H:%M:%S'),
          stake:         Stake.find_or_create_by(stake: stake),
          bet_structure: bs,
          poker_variant: pv
        )
      end
    end

    transaction do
      xml.xpath('//sessions/tournament').select do |c|
        c.attributes['bankroll'].value == 'Live'
      end.each do |c|
        attrs = c.attributes
        res_attrs = c.xpath('./results/result').first.attributes
        stake = attrs['entryfee'].value
        bs = case attrs['limit'].value
             when '0'
               BetStructure.find_by(name: 'No Limit')
             when '1'
               BetStructure.find_by(name: 'Pot Limit')
             when '2'
               BetStructure.find_by(name: 'Fixed Limit')
             else
               raise 'unknown limit'
             end
        pv = case attrs['variant'].value
             when 'OH|Omaha'
               PokerVariant.find_by(name: 'Omaha')
             when 'Texas Hold\'em|Texas Hold\'em', ''
               PokerVariant.find_by(name: 'Texas Holdem')
             when 'Mixed|Mixed'
               PokerVariant.find_by(name: 'Mix')
             when 'BigO|BigO'
               PokerVariant.find_by(name: 'BigO')
             when 'OH8|Omaha Hi-Low'
               PokerVariant.find_by(name: 'Omaha Hi-Lo')
             else
               raise 'unknown variant'
             end

        PokerSession.create!(
          buyin:         res_attrs['buyin'].value.to_i,
          cashout:       res_attrs['chipcount'].value.to_i,
          start_time:    DateTime.strptime(attrs['startdate'].value, '%m/%d/%y %H:%M:%S'),
          end_time:      DateTime.strptime(attrs['enddate'].value, '%m/%d/%y %H:%M:%S'),
          stake:         Stake.find_or_create_by(stake: stake),
          bet_structure: bs,
          poker_variant: pv
        )
      end
    end
  end
end
