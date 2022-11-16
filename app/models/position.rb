# frozen_string_literal: true

class Position < ApplicationRecord
  POSITION_ORDER = %w[SB BB UTG UTG1 MP LJ HJ CO BU STRADDLE UTG2].freeze

  validates :position, uniqueness: true

  scope :custom_order, -> { order(POSITION_ORDER.to_custom_sql_order(:position)) }

  def to_s
    position
  end

  def self.cached
    @cached ||= Position.custom_order.pluck(:id, :position)
  end
end
