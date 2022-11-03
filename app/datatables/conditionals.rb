module Conditionals
  private

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
