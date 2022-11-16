# frozen_string_literal: true

module CustomNumericMods
  def to_elapsed_time
    mins = (self.to_i / 60) % 60
    hrs  = (self.to_i / 3600)
    "#{hrs}:#{'%02d' % mins}"
  end
end

class Numeric
  include CustomNumericMods
end
