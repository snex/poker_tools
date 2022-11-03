class CreateVillainHands < ActiveRecord::Migration[7.0]
  def change
    create_table :villain_hands do |t|
      t.references :hand_history, foreign_key: true
      t.references :hand,         foreign_key: true
    end
  end
end
