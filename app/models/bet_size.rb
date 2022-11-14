class BetSize < ApplicationRecord
  BET_SIZE_ORDER = ['limp', '2b', '3b', '4b', '5b', '6b'].freeze

  validates_uniqueness_of :bet_size, :description, :color

  def to_s
    self.description
  end

  def self.cached
    @@cached ||= BetSize.pluck(:description).map { |d| { value: d, label: d } }.to_json
  end
end
