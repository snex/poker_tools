# frozen_string_literal: true

class BetStructure < ApplicationRecord
  validates :name, :abbreviation, uniqueness: true
end
