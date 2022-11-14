class PokerVariant < ApplicationRecord
  validates_uniqueness_of :name, :abbreviation
end
