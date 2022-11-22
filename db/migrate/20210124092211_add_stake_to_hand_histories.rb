# frozen_string_literal: true

class AddStakeToHandHistories < ActiveRecord::Migration[6.1]
  def change
    change_table :hand_histories do |t|
      t.references :stake
    end
  end
end
