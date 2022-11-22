# frozen_string_literal: true

class CreatePokerSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :bet_structures do |t|
      t.string :name,         null: false
      t.string :abbreviation, null: false

      t.timestamps
    end

    create_table :poker_variants do |t|
      t.string :name,         null: false
      t.string :abbreviation, null: false

      t.timestamps
    end

    create_table :poker_sessions do |t|
      t.integer    :buyin,         null: false
      t.integer    :cashout,       null: false
      t.datetime   :start_time,    null: false
      t.datetime   :end_time,      null: false
      t.integer    :hands_dealt
      t.references :stake,         null: false
      t.references :bet_structure, null: false
      t.references :poker_variant, null: false

      t.timestamps
    end

    add_foreign_key :poker_sessions, :stakes
    add_foreign_key :poker_sessions, :bet_structures
    add_foreign_key :poker_sessions, :poker_variants
  end
end
