# frozen_string_literal: true

class AddShowdownToHandHistories < ActiveRecord::Migration[6.0]
  def change
    change_table :hand_histories do |t|
      t.boolean :showdown, default: false
    end
  end
end
