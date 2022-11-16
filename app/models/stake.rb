class Stake < ApplicationRecord
  before_save :set_stakes_array

  def to_s
    stake
  end

  def self.cached
    # stakes cannot be memoized because they can dynamically be created,
    # but we will maintain the naming scheme for simplicity sake
    Stake.order(:stakes_array).pluck(:id, :stake)
  end

  private

  def set_stakes_array
    self.stakes_array = self.stake.split('/').reverse.map { |s| Integer(s) }
  end
end
