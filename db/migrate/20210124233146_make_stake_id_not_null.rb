class MakeStakeIdNotNull < ActiveRecord::Migration[6.1]
  def change
    change_column :hand_histories, :stake_id, :integer, null: false
  end
end
