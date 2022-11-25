# frozen_string_literal: true

class CreateSharedHandHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :shared_hand_histories do |t|
      t.references :hand_history, null: false, foreign_key: true
      t.string     :uuid,         null: false
      t.datetime   :expires_at,   null: false

      t.timestamps
    end

    add_index :shared_hand_histories, :uuid, unique: true
  end
end
