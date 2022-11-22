# frozen_string_literal: true

class AddStakesArrayToStakes < ActiveRecord::Migration[6.1]
  def change
    change_table :stakes do |t|
      t.integer :stakes_array, array: true
    end
  end
end
