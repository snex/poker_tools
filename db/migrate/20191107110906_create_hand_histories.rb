# frozen_string_literal: true

class CreateHandHistories < ActiveRecord::Migration[6.0]
  def change
    create_table :hand_histories do |t|
      t.date       :date,       null: false
      t.integer    :result,     null: false
      t.references :hand,       null: false
      t.references :position,   null: false
      t.references :bet_size,   null: false
      t.references :table_size, null: false
      t.string     :flop
      t.string     :turn
      t.string     :river
      t.text       :note

      t.timestamps
    end

    add_foreign_key :hand_histories, :hands
  end
end
