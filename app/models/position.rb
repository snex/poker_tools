class Position < ApplicationRecord
  POSITION_ORDER = ['SB', 'BB', 'UTG', 'UTG1', 'MP', 'LJ', 'HJ', 'CO', 'BU', 'STRADDLE', 'UTG2']

  def to_s
    self.position
  end

  def self.cached
    @@cached ||= Position.all.map { |p| {value: p.to_s, label: p.to_s} }.to_json
  end
end
