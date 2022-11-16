# frozen_string_literal: true

class PokerVariant < ApplicationRecord
  validates :name, :abbreviation, uniqueness: true
end
