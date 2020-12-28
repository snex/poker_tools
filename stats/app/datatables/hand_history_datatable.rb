class HandHistoryDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    @view_columns ||= {
      date:       { source: 'HandHistory.date', cond: :date_range, delimiter: '-yadcf_delim-' },
      result:     { source: 'HandHistory.result', cond: between_condition },
      hand:       { source: 'Hand.hand', cond: :string_eq },
      position:   { source: 'Position.position', cond: :string_eq },
      bet_size:   { source: 'BetSize.description', cond: :string_eq },
      table_size: { source: 'TableSize.description', cond: :string_eq },
      flop:       { source: 'HandHistory.flop', cond: not_null_condition },
      turn:       { source: 'HandHistory.turn', cond: not_null_condition },
      river:      { source: 'HandHistory.river', cond: not_null_condition },
      showdown:   { source: 'HandHistory.showdown', cond: boolean_condition },
      all_in:     { source: 'HandHistory.all_in', cond: boolean_condition },
      note:       { source: 'HandHistory.note' }
    }
  end

  private

  def data
    records.includes(:hand, :position, :bet_size, :table_size).map do |record|
      {
        date:       record.date,
        result:     record.result,
        hand:       record.hand,
        position:   record.position,
        bet_size:   record.bet_size.description,
        table_size: record.table_size.description,
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
    HandHistory.all.includes(:hand, :position, :bet_size, :table_size).joins(:hand, :position, :bet_size, :table_size).order(:id)
  end

  def between_condition
    ->(column, _) do 
      min, max = column.search.value.split('-yadcf_delim-')
      use_abs = (min.try(:[], 0) == '!')

      if use_abs
        min = min[1..-1]
      end

      if min.blank?
        min = -Float::INFINITY
      else
        min = min.to_i
      end
      if max.blank?
        max = Float::INFINITY
      else
        max = max.to_i
      end

      if use_abs
        column.table[column.field].abs.between(min..max)
      else
        column.table[column.field].between(min..max)
      end
    end
  end

  def boolean_condition
    ->(column, _) do
      column.table[column.field].eq(column.search.value)
    end
  end

  def not_null_condition
    ->(column, _) do
      if column.search.value == 'true'
        column.table[column.field].not_eq(nil)
      else
        column.table[column.field].eq(nil)
      end
    end
  end

end
