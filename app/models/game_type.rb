# frozen_string_literal: true

class GameType < ApplicationRecord
  class UnknownGameTypeException < StandardError; end

  belongs_to :bet_structure
  belongs_to :poker_variant
  belongs_to :stake

  validates :game_type, uniqueness: true
  validates :bet_structure_id, uniqueness: { scope: %i[poker_variant_id stake_id] }

  before_save :set_game_type

  def to_s
    "#{stake} #{bet_structure.abbreviation}#{poker_variant.abbreviation}"
  end

  private

  def set_game_type
    self.game_type = "#{stake.stake} #{bet_structure.abbreviation}#{poker_variant.abbreviation}"
  end
end
