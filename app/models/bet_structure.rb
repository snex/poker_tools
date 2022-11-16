# frozen_string_literal: true

class BetStructure < ApplicationRecord
  validates_uniqueness_of :name, :abbreviation
end
