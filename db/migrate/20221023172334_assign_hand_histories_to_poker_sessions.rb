# frozen_string_literal: true

class AssignHandHistoriesToPokerSessions < ActiveRecord::Migration[7.0]
  def up
    HandHistory.update_old_records
  end

  def down
    HandHistory.update_all(poker_session_id: nil)
  end
end
