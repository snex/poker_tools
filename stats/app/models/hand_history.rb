require 'google_drive'

class HandHistory < ApplicationRecord
  belongs_to :hand
  belongs_to :position
  belongs_to :bet_size
  belongs_to :table_size
  belongs_to :stake

  def self.import(filename, stats_sheet)
    date = File.basename(filename.split('.')[0], '.*')
    data = File.new(filename).readlines.join.split("\n\n")

    if stats_sheet.blank?
      puts "No spreadsheet ID given, skipping sheet entry"
    else
      hands = data.size
      saw_flop = data.select { |d| d.match?(/Flop/) }.size
      wtsd = data.select { |d| d.match?(/Vs? (show|muck)/) }.size
      wmsd = data.select { |d| d.match?(/Vs? (show|muck)/) && d.match?(/\+/) }.size
      puts ""
      puts "SD stats"
      puts "============================"
      puts "Hands: #{hands}"
      puts "Saw Flop: #{saw_flop}"
      puts "WTSD: #{wtsd}"
      puts "W$SD: #{wmsd}"
      puts "============================"
      session = GoogleDrive::Session.from_config(Rails.root.join('config.json').to_s)
      ws = session.spreadsheet_by_key(stats_sheet).worksheet_by_title('SD Stats')
      row = 0
      (1..ws.num_rows).each do |col|
        row += 1
        break if ws[row, 1].empty?
      end
      ws[row, 1] = date
      ws[row, 3] = hands
      ws[row, 4] = saw_flop
      ws[row, 5] = wtsd
      ws[row, 6] = wmsd
      ws.save
      puts "Data entered into spreadsheet"
    end

    transaction do
      stake = nil

      data.each do |d|
        d.strip!
        puts d

        if d.match?(/^stakes .*/i)
          stake = Stake.find_or_create_by(stake: d.match(/^stakes (.*)$/i)[1])
          puts "Setting stake to #{stake}"
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

        puts "res: #{res}, pos: #{pos}, hand: #{hand}, size: #{size}, tbl_size: #{tbl_size}, allin: #{all_in}, showdown: #{showdown}, flop: #{flop}, turn: #{turn}, river: #{river}"

        HandHistory.create!(
          date:       date,
          result:     res.to_i,
          hand:       hand,
          position:   pos,
          bet_size:   size,
          table_size: tbl_size,
          stake:      stake,
          flop:       flop,
          turn:       turn,
          river:      river,
          note:       note,
          all_in:     all_in,
          showdown:   showdown
        )

      end
    end
  end
end
