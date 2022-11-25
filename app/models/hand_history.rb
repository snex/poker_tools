# frozen_string_literal: true

class HandHistory < ApplicationRecord
  include HandHistoryFilterScopes

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

  def share_link
    ApplicationController.helpers.link_to(
      ApplicationController.helpers.fa_icon('share'),
      Rails.application.routes.url_helpers.share_hand_history_path(self),
      {
        method: 'POST',
        target: '_new'
      }
    )
  end

  def self.aggregates(joins, group_by, params)
    {
      sums:   aggregate_sums(joins, group_by, params),
      counts: aggregate_counts(joins, group_by, params),
      pct_w:  aggregate_pct_w(joins, group_by, params),
      avgs:   aggregate_avgs(joins, group_by, params)
    }
  end

  private_class_method def self.partial_query_for_aggregates(joins, group_by, params)
    includes(:hand, :position, :bet_size, :table_size, poker_session: { game_type: :stake })
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
