# frozen_string_literal: true

class PopulateGameTypes < ActiveRecord::Migration[7.0]
  def up
    PokerSession
      .joins(:stake, :bet_structure, :poker_variant)
      .pluck(Arel.sql('distinct stakes.id, bet_structures.id, poker_variants.id'))
      .each do |stake, bs, pv|
      GameType.create!(
        stake_id:         stake,
        bet_structure_id: bs,
        poker_variant_id: pv
      )
    end
  end

  def down
    GameType.delete_all
  end
end
