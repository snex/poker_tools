# frozen_string_literal: true

class AddBankrollTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :bankroll_transactions do |t|
      t.date    :date, null: false
      t.integer :amount, null: false
      t.text    :note

      t.timestamps
    end
  end
end
