class AddAllInToHandHistories < ActiveRecord::Migration[6.0]
  def change
    change_table :hand_histories do |t|
      t.boolean :all_in, default: false
    end
  end
end
