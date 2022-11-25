# frozen_string_literal: true

module HandHistoryFilterScopes
  extend ActiveSupport::Concern
  include HandHistoryGenericFilterScopes

  included do
    scope :filter_bet_size,   ->(bs)       { filter_by_join(:bet_size, bs) }
    scope :filter_hand,       ->(h)        { filter_by_join(:hand, h) }
    scope :filter_position,   ->(p)        { filter_by_join(:position, p) }
    scope :filter_stake,      ->(s)        { filter_by_join('stakes.id', s, { poker_session: { game_type: :stake } }) }
    scope :filter_table_size, ->(ts)       { filter_by_join(:table_size, ts) }
    scope :filter_times,      ->(from, to) { joins(:poker_session).where(poker_sessions: { start_time: from..to }) }
    scope :filter_flop,       ->(f)        { filter_by_presence(:flop, f) }
    scope :filter_turn,       ->(t)        { filter_by_presence(:turn, t) }
    scope :filter_river,      ->(r)        { filter_by_presence(:river, r) }
    scope :filter_showdown,   ->(sd)       { filter_boolean(:showdown, sd) }
    scope :filter_all_in,     ->(ai)       { filter_boolean(:all_in, ai) }
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
  end
end
