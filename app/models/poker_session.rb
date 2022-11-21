# frozen_string_literal: true

class PokerSession < ApplicationRecord
  belongs_to :stake
  belongs_to :bet_structure
  belongs_to :poker_variant
  has_many :hand_histories, dependent: :restrict_with_exception

  extend PokerSessionsStats

  def game_type
    @game_type ||= "#{stake.stake} #{bet_structure.abbreviation}#{poker_variant.abbreviation}"
  end

  def result
    @result ||= cashout - buyin
  end

  def duration
    @duration ||= (end_time - start_time).to_i
  end

  def hourly
    @hourly ||= (result / (duration / 3600.0)).round(2)
  end

  def hands_played
    @hands_played ||= hand_histories.count
  end

  def saw_flop
    @saw_flop ||= hand_histories.saw_flop.count
  end

  def wtsd
    @wtsd ||= hand_histories.showdown.count
  end

  def wmsd
    @wmsd ||= hand_histories.won.showdown.count
  end

  def vpip
    @vpip ||= (hands_played / hands_dealt.to_f).round(2)
  end

  def self.iterable_years
    (minimum(:start_time).year..maximum(:start_time).year).sort { |a, b| b <=> a }
  end

  def self.iterable_months
    (minimum(:start_time).beginning_of_month.to_date..maximum(:start_time).beginning_of_month.to_date)
      .to_a
      .select { |d| d.day == 1 }
      .sort { |a, b| b <=> a }
  end
end
