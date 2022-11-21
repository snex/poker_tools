# frozen_string_literal: true

class HandHistory < ApplicationRecord
  belongs_to :hand
  belongs_to :position
  belongs_to :bet_size
  belongs_to :table_size
  belongs_to :poker_session, optional: true
  has_many   :villain_hands, dependent: :delete_all

  scope :saw_flop, -> { where.not(flop: nil) }
  scope :saw_turn, -> { where.not(turn: nil) }
  scope :saw_river, -> { where.not(river: nil) }
  scope :showdown, -> { where(showdown: true) }
  scope :all_in, -> { where(all_in: true) }
  scope :won, -> { where(result: 0..Float::INFINITY) }
  scope :lost, -> { where(result: Float::INFINITY...0) }
  scope :with_poker_sessions, ->(ps) { joins(:poker_session).where(poker_session_id: ps) }

  scope :filter_bet_size, lambda { |bet_size|
    bet_size.present? ? where(bet_size: bet_size) : all
  }
  scope :filter_hand, lambda { |hand|
    hand.present? ? where(hand: hand) : all
  }
  scope :filter_position, lambda { |position|
    position.present? ? where(position: position) : all
  }
  scope :filter_stake, lambda { |stake|
    stake.present? ? joins(poker_session: :stake).where(poker_sessions: { stake: stake }) : all
  }
  scope :filter_table_size, lambda { |table_size|
    table_size.present? ? where(table_size: table_size) : all
  }
  scope :filter_times, lambda { |from, to|
    if from.present? && to.present?
      joins(:poker_session).where(poker_sessions: { start_time: from..to })
    elsif from.present?
      joins(:poker_session).where('poker_sessions.start_time >= ?', from)
    elsif to.present?
      joins(:poker_session).where('poker_sessions.start_time <= ?', to)
    else
      all
    end
  }
  scope :filter_by_presence, lambda { |attr, value|
    # NOTE: since these params come directly from controllers, booleans are assumed to be strings
    # with 'true' or 'false' as values
    return all if value.blank?

    ActiveModel::Type::Boolean.new.cast(value) ? where.not("#{attr}": nil) : where("#{attr}": nil)
  }
  scope :filter_boolean, lambda { |attr, value|
    # NOTE: since these params come directly from controllers, booleans are assumed to be strings
    # with 'true' or 'false' as values
    return all if value.blank?

    ActiveModel::Type::Boolean.new.cast(value) ? where("#{attr}": true) : where("#{attr}": false)
  }
  scope :filter_flop, ->(flop) { filter_by_presence(:flop, flop) }
  scope :filter_turn, ->(turn) { filter_by_presence(:turn, turn) }
  scope :filter_river, ->(river) { filter_by_presence(:river, river) }
  scope :filter_showdown, ->(showdown) { filter_boolean(:showdown, showdown) }
  scope :filter_all_in, ->(all_in) { filter_boolean(:all_in, all_in) }
  scope :custom_filter, lambda { |params|
    filter_bet_size(params[:bet_size])
      .filter_hand(params[:hand])
      .filter_position(params[:position])
      .filter_stake(params[:stake])
      .filter_table_size(params[:table_size])
      .filter_times(params[:from], params[:to])
      .filter_flop(params[:flop])
      .filter_turn(params[:turn])
      .filter_river(params[:river])
      .filter_showdown(params[:showdown])
      .filter_all_in(params[:all_in])
  }

  def self.aggregates(joins, group_by, params)
    {
      sums:   aggregate_sums(joins, group_by, params),
      counts: aggregate_counts(joins, group_by, params),
      pct_w:  aggregate_pct_w(joins, group_by, params),
      avgs:   aggregate_avgs(joins, group_by, params)
    }
  end

  private_class_method def self.partial_query_for_aggregates(joins, group_by, params)
    includes(:hand, :position, :bet_size, :table_size, poker_session: :stake)
      .joins(joins)
      .custom_filter(params)
      .group(group_by)
  end

  private_class_method def self.aggregate_sums(joins, group_by, params)
    partial_query_for_aggregates(joins, group_by, params).sum(:result)
  end

  private_class_method def self.aggregate_counts(joins, group_by, params)
    partial_query_for_aggregates(joins, group_by, params).count(:id)
  end

  private_class_method def self.aggregate_pct_w(joins, group_by, params)
    partial_query_for_aggregates(joins, group_by, params).won.count.each_with_object({}) do |(obj, count), h|
      h[obj] = (100 * count.to_f / aggregate_counts(joins, group_by, params)[obj].to_f).round(2)
    end
  end

  private_class_method def self.aggregate_avgs(joins, group_by, params)
    partial_query_for_aggregates(joins, group_by, params).average(:result).transform_values { |v| v.round(2) }
  end
end
