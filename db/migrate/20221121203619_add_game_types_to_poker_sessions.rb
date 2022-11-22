# frozen_string_literal: true

class AddGameTypesToPokerSessions < ActiveRecord::Migration[7.0]
  def change
    change_table :poker_sessions do |t|
      t.references :game_type
    end

    add_foreign_key :poker_sessions, :game_types
  end
end
