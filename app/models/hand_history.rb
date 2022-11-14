class HandHistory < ApplicationRecord
  belongs_to :hand
  belongs_to :position
  belongs_to :bet_size
  belongs_to :table_size
  belongs_to :poker_session, optional: true
  has_many   :villain_hands, dependent: :delete_all

  def self.import(poker_session, data)
    transaction do
      data.strip!
      note, _, status_line = data.rpartition("\n")
      res, pos, hand, size, tbl_size = status_line.split(' ', 5).map { |l| l.strip }
      tbl_size = 9 if tbl_size.nil?
      hand = hand[0].upcase + hand[1].upcase + hand[2].try(:downcase).to_s
      pos.upcase!

      if size == 'limp'
        size = 1
      else
        size = size.delete('^2-6').to_i
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

      if showdown
        v_hands = note.scan(/Vs? show (.+)/).map { |str| Hand.from_str(str.first.split(' ').first) }
      end

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
