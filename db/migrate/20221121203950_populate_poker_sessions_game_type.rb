# frozen_string_literal: true

class PopulatePokerSessionsGameType < ActiveRecord::Migration[7.0]
  def up
    PokerSession.all.each do |ps|
      gt = GameType.find_by!(stake: ps.stake_id, bet_structure: ps.bet_structure_id, poker_variant: ps.poker_variant_id)
      Rails.logger.error "GameType: #{gt}"
      ps.update!(game_type_id: gt.id)
      Rails.logger.error "PokerSession: #{ps.game_type}"
    end
  end

  def down
    PokerSession.all.each do |ps|
      ps.update!(game_type_id: nil)
    end
  end
end
