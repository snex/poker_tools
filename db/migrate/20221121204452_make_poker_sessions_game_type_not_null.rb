# frozen_string_literal: true

class MakePokerSessionsGameTypeNotNull < ActiveRecord::Migration[7.0]
  def up
    change_column :poker_sessions, :game_type_id, :integer, null: false
  end

  def down
    change_column :poker_sessions, :game_type_id, :integer, null: true
  end
end
