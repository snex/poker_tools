# frozen_string_literal: true

class MakeHandHistoriesPokerSessionIdNotNull < ActiveRecord::Migration[7.0]
  def change
    change_column_null :hand_histories, :poker_session_id, false
  end
end
