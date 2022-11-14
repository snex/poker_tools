class Position < ApplicationRecord
  POSITION_ORDER = ['SB', 'BB', 'UTG', 'UTG1', 'MP', 'LJ', 'HJ', 'CO', 'BU', 'STRADDLE', 'UTG2']

  validates_uniqueness_of :position

  def to_s
    self.position
  end

  def self.cached
    @@cached ||= Position.pluck(:position).map { |p| { value: p, label: p } }.to_json
  end
end
