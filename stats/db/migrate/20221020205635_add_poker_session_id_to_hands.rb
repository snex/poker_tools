class AddPokerSessionIdToHands < ActiveRecord::Migration[7.0]
  def change
    change_table :hand_histories do |t|
      t.references :poker_session
    end

    add_foreign_key :hand_histories, :poker_sessions
  end
end
