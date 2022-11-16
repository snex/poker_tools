# frozen_string_literal: true

class BetSize < ApplicationRecord
  BET_SIZE_ORDER = ['limp', '2b', '3b', '4b', '5b', '6b'].freeze

  validates_uniqueness_of :bet_size, :description, :color

  scope :custom_order, -> do
    order(BET_SIZE_ORDER.to_custom_sql_order(:description))
  end

  def to_s
    self.description
  end

  def self.cached
    @@cached ||= BetSize.custom_order.pluck(:id, :description)
  end
end
