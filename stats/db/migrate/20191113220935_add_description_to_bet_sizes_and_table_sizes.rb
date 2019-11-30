class AddDescriptionToBetSizesAndTableSizes < ActiveRecord::Migration[6.0]
  def change
    change_table :bet_sizes do |t|
      t.string :description
    end

    change_table :table_sizes do |t|
      t.string :description
    end
  end
end
