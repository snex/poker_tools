class HandHistory < ApplicationRecord
  belongs_to :hand
  belongs_to :position
  belongs_to :bet_size
  belongs_to :table_size
  belongs_to :stake,         optional: true
  belongs_to :poker_session, optional: true
  has_many   :villain_hands, dependent: :delete_all

  def self.import(date, filename)
    data = File.new(filename).readlines.join.split("\n\n")

    transaction do
      new_ps = nil

      data.each do |d|
        d.strip!
        puts d

        if d.match?(/^session .*/i)
          session_lines = d.split("\n")
          stake = bs = pv = start_time = end_time = buyin = cashout = hands_dealt = nil

          session_lines.each do |sl|
            sl.strip!

            if sl.match?(/^session .*/i)
              game_type = d.match(/^session (.*)$/i)[1]
              stake_name, game_name = game_type.split(' ')
              stake = Stake.find_or_create_by(stake: stake_name)

              if game_name.blank?
                raise 'No Game Name supplied'
              end

              case game_name.downcase
              when 'nl'
                bs = BetStructure.find_by(name: 'No Limit')
                pv = PokerVariant.find_by(name: 'Texas Holdem')
              when 'bigo'
                bs = BetStructure.find_by(name: 'Pot Limit')
                pv = PokerVariant.find_by(name: 'BigO')
              when 'plo'
                bs = BetStructure.find_by(name: 'Pot Limit')
                pv = PokerVariant.find_by(name: 'Omaha')
              else
                raise "Unknown game type: #{game_name}"
              end

              if bs.blank? || pv.blank?
                raise 'BetStructure or PokerVariant not found!'
              end

              puts "stake: #{stake.stake}, bs: #{bs.name}, pv: #{pv.name}"
            elsif sl.match?(/^start: .*/i)
              start_time = ActiveSupport::TimeZone[Time.zone.name].parse("#{date} #{sl.match(/^start: (.*)$/i)[1]}")
              puts "start_time: #{start_time}"
            elsif sl.match?(/^end: .*/i)
              end_time = ActiveSupport::TimeZone[Time.zone.name].parse("#{date} #{sl.match(/^end: (.*)$/i)[1]}")
              puts "end_time: #{end_time}"
            elsif sl.match?(/^in: .*/i)
              buyin = sl.match(/^in: (.*)$/i)[1].to_i
              puts "buyin: #{buyin}"
            elsif sl.match?(/^out: .*/i)
              cashout = sl.match(/^out: (.*)$/i)[1].to_i
              puts "cashout: #{cashout}"
            elsif sl.match?(/^hands: .*/i)
              hands_dealt = sl.match(/^hands: (.*)$/i)[1].to_i
              puts "hands_dealt: #{hands_dealt}"
            end
          end

          # this can happen if the session goes beyond midnight
          if end_time < start_time
            end_time += 1.day
          end

          new_ps = PokerSession.create!(
            start_time:    start_time,
            end_time:      end_time,
            buyin:         buyin,
            cashout:       cashout,
            hands_dealt:   hands_dealt,
            stake:         stake,
            bet_structure: bs,
            poker_variant: pv
          )
          next
        end

        note, _, status_line = d.rpartition("\n")
        puts "note: #{note}, status_line: #{status_line}"
        res, pos, hand, size, tbl_size = status_line.split(' ', 5).map { |l| l.strip }
        tbl_size = 9 if tbl_size.nil?
        hand = hand[0].upcase + hand[1].upcase + hand[2].try(:downcase).to_s
        pos.upcase!

        if size == 'limp'
          size = 1
        else
          size = size.delete('^2-6').to_i
        end

        showdown = d.match?(/Vs? (show|muck)/)
        all_in = note.match?(/all in/) && (
          status_line[0] == '+' ||
          d.match?(/Vs? (show|muck)/)
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
          v_hands = d.scan(/Vs? show (.+)/).map { |str| Hand.from_str(str.first.split(' ').first) }
        end

        puts "res: #{res}, pos: #{pos}, hand: #{hand}, size: #{size}, tbl_size: #{tbl_size}, allin: #{all_in}, showdown: #{showdown}, flop: #{flop}, turn: #{turn}, river: #{river}"
        puts "v_hands: #{v_hands.map(&:hand)}"

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
          poker_session: new_ps
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

  def self.update_old_records
    transaction do
      bs = BetStructure.find_by(name: 'No Limit')
      pv = PokerVariant.find_by(name: 'Texas Holdem')

      HandHistory.where(poker_session: nil).pluck('distinct date, stake_id').each do |date, s_id|
        ps = PokerSession.
          where(bet_structure: bs, poker_variant: pv, stake_id: s_id).
          where('start_time between ? and ?', date.at_midnight, (date + 1.day).at_midnight - 1.second).
          first

        if ps.blank?
          puts "No PokerSession found for date: #{date} and stake: #{s_id}"
        end

        hh = HandHistory.where(poker_session: nil, date: date, stake_id: s_id)
        hh.update_all(poker_session_id: ps.id)
      end
    end
  end
end
