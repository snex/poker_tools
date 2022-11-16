# frozen_string_literal: true

class PokerSessionDatatable < AjaxDatatablesRails::ActiveRecord
  include Conditionals

  def view_columns
    @view_columns ||= {
      start_time:   { source: 'PokerSession.start_time', cond: :date_range, delimiter: '-yadcf_delim-' },
      end_time:     { source: 'PokerSession.end_time', cond: :date_range, delimiter: '-yadcf_delim-' },
      duration:     { source: 'PokerSession.duration' },
      game_type:    { source: 'PokerSession.game_type' },
      buyin:        { source: 'PokerSession.buyin' },
      cashout:      { source: 'PokerSession.cashout' },
      result:       { source: 'PokerSession.result' },
      hands_dealt:  { source: 'PokerSession.hands_dealt' },
      hands_played: { source: 'PokerSession.hands_played' },
      saw_flop:     { source: 'PokerSession.saw_flop' },
      wtsd:         { source: 'PokerSession.wtsd' },
      wmsd:         { source: 'PokerSession.wmsd' },
      vpip:         { source: 'PokerSession.vpip' }
    }
  end

  private

  def data
    records.includes(:stake, :bet_structure, :poker_variant).map do |record|
      {
        start_time:   record.start_time.strftime('%Y-%m-%d %l:%M %p'),
        end_time:     record.end_time.strftime('%Y-%m-%d %l:%M %p'),
        duration:     record.duration.to_elapsed_time,
        game_type:    record.game_type,
        buyin:        record.buyin,
        cashout:      record.cashout,
        result:       record.result,
        hands_dealt:  record.hands_dealt,
        hands_played: record.hands_played,
        saw_flop:     record.saw_flop,
        wtsd:         record.wtsd,
        wmsd:         record.wmsd,
        vpip:         record.vpip,
        DT_RowId:     record.id
      }
    end
  end

  def get_raw_records
    PokerSession.all.includes(:stake, :bet_structure, :poker_variant).joins(:stake, :bet_structure, :poker_variant)
  end
end
