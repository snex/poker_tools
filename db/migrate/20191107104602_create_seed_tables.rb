# frozen_string_literal: true

class CreateSeedTables < ActiveRecord::Migration[6.0]
  def change
    create_table :hands do |t|
      t.string :hand
    end

    create_table :bet_sizes do |t|
      t.integer :bet_size
    end

    create_table :positions do |t|
      t.string :position
    end

    create_table :table_sizes do |t|
      t.integer :table_size
    end
  end
end
