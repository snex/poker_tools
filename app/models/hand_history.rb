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
  scope :custom_filter, lambda { |params|
    relation = all
    if params[:bet_size].present?
      relation = relation
                 .where(bet_size: params[:bet_size])
    end
    if params[:hand].present?
      relation = relation
                 .where(hand: params[:hand])
    end
    if params[:position].present?
      relation = relation
                 .where(position: params[:position])
    end
    if params[:stake].present?
      relation = relation
                 .joins(poker_session: :stake)
                 .where(poker_sessions: { stake: params[:stake] })
    end
    if params[:table_size].present?
      relation = relation
                 .where(table_size: params[:table_size])
    end

    if params[:from].present? && params[:to].present?
      relation = relation.joins(:poker_session).where(poker_sessions: { start_time: params[:from]..params[:to] })
    elsif params[:from].present?
      relation = relation.joins(:poker_session).where('poker_sessions.start_time >= ?', params[:from])
    elsif params[:to].present?
      relation = relation.joins(:poker_session).where('poker_sessions.start_time <= ?', params[:to])
    end
    # NOTE: since these params come directly from controllers, booleans are assumed to be strings
    # with 'true' or 'false' as values
    if params[:flop].present?
      relation = if ActiveModel::Type::Boolean.new.cast(params[:flop])
                   relation.saw_flop
                 else
                   relation.where(flop: nil)
                 end
    end
    if params[:turn].present?
      relation = if ActiveModel::Type::Boolean.new.cast(params[:turn])
                   relation.saw_turn
                 else
                   relation.where(turn: nil)
                 end
    end
    if params[:river].present?
      relation = if ActiveModel::Type::Boolean.new.cast(params[:river])
                   relation.saw_river
                 else
                   relation.where(river: nil)
                 end
    end
    if params[:showdown].present?
      relation = relation
                 .where(showdown: ActiveModel::Type::Boolean.new.cast(params[:showdown]))
    end
    if params[:all_in].present?
      relation = relation
                 .where(all_in: ActiveModel::Type::Boolean.new.cast(params[:all_in]))
    end

    relation
  }

  def self.import(poker_session, data)
    transaction do
      data.strip!
      note, _, status_line = data.rpartition("\n")
      res, pos, hand, size, tbl_size = status_line.split(' ', 5).map(&:strip)
      tbl_size = 9 if tbl_size.nil?
      hand = hand[0].upcase + hand[1].upcase + hand[2].try(:downcase).to_s
      pos.upcase!

      size = if size == 'limp'
               1
             else
               size.delete('^2-6').to_i
             end

      showdown = note.match?(/Vs? (show|muck)/)
      all_in = note.match?(/all in/) && (
        status_line[0] == '+' ||
        note.match?(/Vs? (show|muck)/)
      )
      flop = note.match(/Flop (.*?),/).try(:[], 1)
      turn = note.match(/Turn (.*?),/).try(:[], 1)
      river = note.match(/River (.*?),/).try(:[], 1)

      hand = Hand.find_by!(hand: hand)
      pos = Position.find_by!(position: pos)
      size = BetSize.find_by!(bet_size: size)
      tbl_size = TableSize.find_by!(table_size: tbl_size)
      v_hands = []

      v_hands = note.scan(/Vs? show (.+)/).map { |str| Hand.from_str(str.first.split.first) } if showdown

      hh = HandHistory.create!(
        result:        res.to_i,
        hand:          hand,
        position:      pos,
        bet_size:      size,
        table_size:    tbl_size,
        flop:          flop,
        turn:          turn,
        river:         river,
        note:          note,
        all_in:        all_in,
        showdown:      showdown,
        poker_session: poker_session
      )
      v_hands.each do |v_hand|
        VillainHand.create!(
          hand:         v_hand,
          hand_history: hh
        )
      end
    end
  end
end
