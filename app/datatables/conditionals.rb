# frozen_string_literal: true

module Conditionals
  private

  def int_eq_condition
    # a bug in the datatables gem and/or yadcf prevents numeric conditionals on bigint, so here we will force it
    lambda { |column, _|
      column.table[column.field].eq_any(column.search.value.split('|').map(&:to_i))
    }
  end

  def str_like_condition
    # a bug in datatables tries to coerce something into a VARCHAR which throws an error, so here we will force it
    lambda { |column, _|
      column.table[column.field].matches("%#{column.search.value}%")
    }
  end

  def between_condition
    lambda { |column, _|
      min, max = column.search.value.split('-yadcf_delim-')
      use_abs = (min.try(:[], 0) == '!')
      min = min[1..] if use_abs

      min = if min.blank?
              -Float::INFINITY
            else
              min.to_i
            end

      max = if max.blank?
              Float::INFINITY
            else
              max.to_i
            end

      if use_abs
        column.table[column.field].abs.between(min..max)
      else
        column.table[column.field].between(min..max)
      end
    }
  end

  def boolean_condition
    lambda { |column, _|
      column.table[column.field].eq(column.search.value)
    }
  end

  def not_null_condition
    lambda { |column, _|
      if column.search.value == 'true'
        column.table[column.field].not_eq(nil)
      else
        column.table[column.field].eq(nil)
      end
    }
  end
end
