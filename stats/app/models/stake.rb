class Stake < ApplicationRecord
  before_save :set_stakes_array

  def to_s
    stake
  end

  def self.cached
    @@cached ||= Stake.pluck(:stake).map { |s| { value: s, label: s } }.to_json
  end

  private

  def set_stakes_array
    self.stakes_array = self.stake.split('/').reverse.map(&:to_i)
  end
end
