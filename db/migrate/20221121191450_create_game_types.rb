# frozen_string_literal: true

class CreateGameTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :game_types do |t|
      t.string     :game_type,     null: false
      t.references :stake,         null: false
      t.references :bet_structure, null: false
      t.references :poker_variant, null: false

      t.timestamps
    end

    add_fks_and_index
  end

  private

  def add_fks_and_index
    add_foreign_key :game_types, :stakes
    add_foreign_key :game_types, :bet_structures
    add_foreign_key :game_types, :poker_variants
    add_index :game_types, :game_type, unique: true
    add_index :game_types, %i[stake_id bet_structure_id poker_variant_id], unique: true, name: 'game_types_unique'
  end
end
