# frozen_string_literal: true

class AddColorToTables < ActiveRecord::Migration[6.0]
  def change
    change_table :positions do |t|
      t.string :color
    end

    change_table :bet_sizes do |t|
      t.string :color
    end
  end
end
