class BetStructure < ApplicationRecord
  validates_uniqueness_of :name, :abbreviation
end
