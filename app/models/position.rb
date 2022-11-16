class Position < ApplicationRecord
  POSITION_ORDER = ['SB', 'BB', 'UTG', 'UTG1', 'MP', 'LJ', 'HJ', 'CO', 'BU', 'STRADDLE', 'UTG2']

  validates_uniqueness_of :position

  scope :custom_order, -> do
    order(POSITION_ORDER.to_custom_sql_order(:position))
  end

  def to_s
    self.position
  end

  def self.cached
    @@cached ||= Position.custom_order.pluck(:id, :position)
  end
end
