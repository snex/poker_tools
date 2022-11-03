class RemoveStakeIdAndDateFromHandHistories < ActiveRecord::Migration[7.0]
  def change
    remove_column :hand_histories, :stake_id
    remove_column :hand_histories, :date
  end
end
