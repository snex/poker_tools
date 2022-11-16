# frozen_string_literal: true

class AddIndexToHandHistoriesDate < ActiveRecord::Migration[6.0]
  def change
    add_index :hand_histories, :date
  end
end
