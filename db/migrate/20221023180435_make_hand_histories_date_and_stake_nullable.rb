# frozen_string_literal: true

class MakeHandHistoriesDateAndStakeNullable < ActiveRecord::Migration[7.0]
  def change
    change_column_null :hand_histories, :date,     true
    change_column_null :hand_histories, :stake_id, true
  end
end
