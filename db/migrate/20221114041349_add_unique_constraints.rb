# frozen_string_literal: true

class AddUniqueConstraints < ActiveRecord::Migration[7.0]
  def change
    add_index :bet_sizes, :bet_size,    unique: true
    add_index :bet_sizes, :description, unique: true
    add_index :bet_sizes, :color,       unique: true

    add_index :bet_structures, :name,         unique: true
    add_index :bet_structures, :abbreviation, unique: true

    add_index :hands, :hand, unique: true

    add_index :poker_variants, :name,         unique: true
    add_index :poker_variants, :abbreviation, unique: true

    add_index :positions, :position, unique: true

    add_index :table_sizes, :table_size,  unique: true
    add_index :table_sizes, :description, unique: true
  end
end
