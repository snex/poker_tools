# frozen_string_literal: true

class BetSize < ApplicationRecord
  BET_SIZE_ORDER = %w[limp 2b 3b 4b 5b 6b].freeze

  validates :bet_size, :description, :color, uniqueness: true

  scope :custom_order, -> { order(BET_SIZE_ORDER.to_custom_sql_order(:description)) }

  def to_s
    description
  end

  def self.cached
    @cached ||= BetSize.custom_order.pluck(:id, :description)
  end
end
