class AddForeignKeys < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :hand_histories, :positions
    add_foreign_key :hand_histories, :bet_sizes
    add_foreign_key :hand_histories, :table_sizes
    add_foreign_key :hand_histories, :stakes
  end
end
