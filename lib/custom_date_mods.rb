# frozen_string_literal: true

module CustomDateMods
  def same_month?(other)
    year == other.year &&
      month == other.month
  end
end

class Date
  include CustomDateMods
end
