# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_01_24_233146) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bet_sizes", force: :cascade do |t|
    t.integer "bet_size"
    t.string "description"
    t.string "color"
  end

  create_table "hand_histories", force: :cascade do |t|
    t.date "date", null: false
    t.integer "result", null: false
    t.bigint "hand_id", null: false
    t.bigint "position_id", null: false
    t.bigint "bet_size_id", null: false
    t.bigint "table_size_id", null: false
    t.string "flop"
    t.string "turn"
    t.string "river"
    t.text "note"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "showdown", default: false
    t.boolean "all_in", default: false
    t.integer "stake_id", null: false
    t.index ["bet_size_id"], name: "index_hand_histories_on_bet_size_id"
    t.index ["date"], name: "index_hand_histories_on_date"
    t.index ["hand_id"], name: "index_hand_histories_on_hand_id"
    t.index ["position_id"], name: "index_hand_histories_on_position_id"
    t.index ["stake_id"], name: "index_hand_histories_on_stake_id"
    t.index ["table_size_id"], name: "index_hand_histories_on_table_size_id"
  end

  create_table "hands", force: :cascade do |t|
    t.string "hand"
  end

  create_table "positions", force: :cascade do |t|
    t.string "position"
    t.string "color"
  end

  create_table "stakes", force: :cascade do |t|
    t.string "stake"
    t.integer "stakes_array", array: true
  end

  create_table "table_sizes", force: :cascade do |t|
    t.integer "table_size"
    t.string "description"
  end

  add_foreign_key "hand_histories", "hands"
end
