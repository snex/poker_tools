class HandHistoryDatatable < AjaxDatatablesRails::ActiveRecord
  include Conditionals

  def view_columns
    @view_columns ||= {
      date:       { source: 'PokerSession.start_time', cond: :date_range,        delimiter: '-yadcf_delim-' },
      result:     { source: 'HandHistory.result',      cond: between_condition                              },
      hand:       { source: 'Hand.id',                 cond: int_eq_condition,   use_regex: false           },
      position:   { source: 'Position.id',             cond: int_eq_condition,   use_regex: false           },
      bet_size:   { source: 'BetSize.id',              cond: int_eq_condition,   use_regex: false           },
      table_size: { source: 'TableSize.id',            cond: int_eq_condition,   use_regex: false           },
      stake:      { source: 'Stake.id',                cond: int_eq_condition,   use_regex: false           },
      flop:       { source: 'HandHistory.flop',        cond: not_null_condition                             },
      turn:       { source: 'HandHistory.turn',        cond: not_null_condition                             },
      river:      { source: 'HandHistory.river',       cond: not_null_condition                             },
      showdown:   { source: 'HandHistory.showdown',    cond: boolean_condition                              },
      all_in:     { source: 'HandHistory.all_in',      cond: boolean_condition                              },
      note:       { source: 'HandHistory.note',        cond: str_like_condition,                            }
    }
  end

  def get_records_for_chart
    records.unscope(:limit, :offset).order('poker_sessions.start_time asc, hand_histories.id asc')
  end

  private

  def data
    records.includes(:hand, :position, :bet_size, :table_size, poker_session: :stake).map do |record|
      {
        date:       record.poker_session.start_time.to_date,
        result:     record.result,
        hand:       record.hand,
        position:   record.position,
        bet_size:   record.bet_size.id,
        table_size: record.table_size.description,
        stake:      record.poker_session.stake.stake,
        flop:       record.flop,
        turn:       record.turn,
        river:      record.river,
        showdown:   record.showdown,
        all_in:     record.all_in,
        note:       record.note.gsub("\n", '<br>').html_safe,
        DT_RowId:   record.id
      }
    end
  end

  def get_raw_records
    HandHistory.all.includes(:hand, :position, :bet_size, :table_size, poker_session: :stake).joins(:hand, :position, :bet_size, :table_size, poker_session: :stake)
  end
end
