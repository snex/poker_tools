# frozen_string_literal: true

class Stake < ApplicationRecord
  before_save :set_stakes_array

  scope :custom_order, -> { order(:stakes_array) }

  def to_s
    stake
  end

  def self.cached
    # stakes cannot be memoized because they can dynamically be created,
    # but we will maintain the naming scheme for simplicity sake
    custom_order.pluck(:id, :stake)
  end

  private

  def set_stakes_array
    self.stakes_array = stake.split('/').reverse.map { |s| Integer(s) }
  end
end
