# frozen_string_literal: true

class RemoveOldPokerSessionsColumns < ActiveRecord::Migration[7.0]
  def up
    change_table :poker_sessions, bulk: true do
      remove_column :poker_sessions, :stake_id
      remove_column :poker_sessions, :bet_structure_id
      remove_column :poker_sessions, :poker_variant_id
    end
  end

  def down
    change_table :poker_sessions do |t|
      t.references :stake
      t.references :bet_structure
      t.references :poker_variant
    end

    add_foreign_key :poker_sessions, :stakes
    add_foreign_key :poker_sessions, :bet_structures
    add_foreign_key :poker_sessions, :poker_variants

    populate_poker_sessions_old_columns
  end

  private

  def populate_poker_sessions_old_columns
    PokerSession.joins(:game_type).each do |ps|
      gt = ps.game_type
      ps.stake = gt.stake
      ps.bet_structure = gt.bet_structure
      ps.poker_variant = gt.poker_variant
      ps.save!
    end
  end
end
