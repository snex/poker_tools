# frozen_string_literal: true

class FileImporter
  class HandHistoryParser
    class HandHistoryParseException < StandardError; end

    def initialize(poker_session, data)
      @poker_session = poker_session
      data.strip!
      @note, _, @status_line = data.rpartition("\n")
      @hh_attrs = {}
      parse_notes
      parse_status_line
    rescue StandardError
      raise HandHistoryParseException, "Error Parsing HandHistory:\nNote: #{@note}\nStatus Line: #{@status_line}"
    end

    def call
      create_hand_history
      create_villain_hands
    end

    private

    def parse_notes
      parse_board
      parse_misc
      parse_v_hands
    end

    def parse_board
      @hh_attrs[:flop] = @note.match(/Flop (.*?),/).try(:[], 1)
      @hh_attrs[:turn] = @note.match(/Turn (.*?),/).try(:[], 1)
      @hh_attrs[:river] = @note.match(/River (.*?),/).try(:[], 1)
    end

    def parse_misc
      @hh_attrs[:showdown] = @note.match?(/Vs? (show|muck)/)
      @hh_attrs[:all_in] = @note.match?(/all in/) && (
        @status_line[0] == '+' ||
        @note.match?(/Vs? (show|muck)/)
      )
    end

    def parse_v_hands
      @v_hands = @note.scan(/Vs? show (.+)/).map { |str| Hand.from_str(str.first.split.first) }
    end

    def parse_status_line
      res, pos, hand, size, tbl_size = @status_line.split(' ', 5).map(&:strip)
      parse_result(res)
      parse_bet_size(size)
      parse_hand(hand)
      parse_position(pos)
      parse_table_size(tbl_size)
    end

    def parse_result(result)
      @hh_attrs[:result] = result
    end

    def parse_bet_size(size)
      size = if size == 'limp'
               1
             else
               size.delete('^2-6').to_i
             end
      @hh_attrs[:bet_size] = BetSize.find_by!(bet_size: size)
    end

    def parse_hand(hand)
      hand = hand[0].upcase + hand[1].upcase + hand[2].try(:downcase).to_s
      @hh_attrs[:hand] = Hand.find_by!(hand: hand)
    end

    def parse_position(pos)
      @hh_attrs[:position] = Position.find_by!(position: pos.upcase)
    end

    def parse_table_size(size)
      size = 9 if size.nil?
      @hh_attrs[:table_size] = TableSize.find_by!(table_size: size)
    end

    def create_hand_history
      @hh = HandHistory.create!(
        @hh_attrs.merge({ poker_session: @poker_session })
      )
    end

    def create_villain_hands
      @v_hands.each do |v_hand|
        VillainHand.create!(
          hand:         v_hand,
          hand_history: @hh
        )
      end
    end
  end
end
