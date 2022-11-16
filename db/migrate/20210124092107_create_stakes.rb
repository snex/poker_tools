# frozen_string_literal: true

class CreateStakes < ActiveRecord::Migration[6.1]
  def change
    create_table :stakes do |t|
      t.string :stake
    end
  end
end
