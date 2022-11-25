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

ActiveRecord::Schema[7.0].define(version: 2022_11_24_191021) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bankroll_transactions", force: :cascade do |t|
    t.date "date", null: false
    t.integer "amount", null: false
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bet_sizes", force: :cascade do |t|
    t.integer "bet_size"
    t.string "description"
    t.string "color"
    t.index ["bet_size"], name: "index_bet_sizes_on_bet_size", unique: true
    t.index ["color"], name: "index_bet_sizes_on_color", unique: true
    t.index ["description"], name: "index_bet_sizes_on_description", unique: true
  end

  create_table "bet_structures", force: :cascade do |t|
    t.string "name", null: false
    t.string "abbreviation", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["abbreviation"], name: "index_bet_structures_on_abbreviation", unique: true
    t.index ["name"], name: "index_bet_structures_on_name", unique: true
  end

  create_table "game_types", force: :cascade do |t|
    t.string "game_type", null: false
    t.bigint "stake_id", null: false
    t.bigint "bet_structure_id", null: false
    t.bigint "poker_variant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bet_structure_id"], name: "index_game_types_on_bet_structure_id"
    t.index ["game_type"], name: "index_game_types_on_game_type", unique: true
    t.index ["poker_variant_id"], name: "index_game_types_on_poker_variant_id"
    t.index ["stake_id", "bet_structure_id", "poker_variant_id"], name: "game_types_unique", unique: true
    t.index ["stake_id"], name: "index_game_types_on_stake_id"
  end

  create_table "hand_histories", force: :cascade do |t|
    t.integer "result", null: false
    t.bigint "hand_id", null: false
    t.bigint "position_id", null: false
    t.bigint "bet_size_id", null: false
    t.bigint "table_size_id", null: false
    t.string "flop"
    t.string "turn"
    t.string "river"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "showdown", default: false
    t.boolean "all_in", default: false
    t.bigint "poker_session_id", null: false
    t.index ["bet_size_id"], name: "index_hand_histories_on_bet_size_id"
    t.index ["hand_id"], name: "index_hand_histories_on_hand_id"
    t.index ["poker_session_id"], name: "index_hand_histories_on_poker_session_id"
    t.index ["position_id"], name: "index_hand_histories_on_position_id"
    t.index ["table_size_id"], name: "index_hand_histories_on_table_size_id"
  end

  create_table "hands", force: :cascade do |t|
    t.string "hand"
    t.index ["hand"], name: "index_hands_on_hand", unique: true
  end

  create_table "poker_sessions", force: :cascade do |t|
    t.integer "buyin", null: false
    t.integer "cashout", null: false
    t.datetime "start_time", null: false
    t.datetime "end_time", null: false
    t.integer "hands_dealt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "game_type_id", null: false
    t.index ["game_type_id"], name: "index_poker_sessions_on_game_type_id"
  end

  create_table "poker_variants", force: :cascade do |t|
    t.string "name", null: false
    t.string "abbreviation", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["abbreviation"], name: "index_poker_variants_on_abbreviation", unique: true
    t.index ["name"], name: "index_poker_variants_on_name", unique: true
  end

  create_table "positions", force: :cascade do |t|
    t.string "position"
    t.string "color"
    t.index ["position"], name: "index_positions_on_position", unique: true
  end

  create_table "shared_hand_histories", force: :cascade do |t|
    t.bigint "hand_history_id", null: false
    t.string "uuid", null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hand_history_id"], name: "index_shared_hand_histories_on_hand_history_id"
    t.index ["uuid"], name: "index_shared_hand_histories_on_uuid", unique: true
  end

  create_table "stakes", force: :cascade do |t|
    t.string "stake"
    t.integer "stakes_array", array: true
  end

  create_table "table_sizes", force: :cascade do |t|
    t.integer "table_size"
    t.string "description"
    t.index ["description"], name: "index_table_sizes_on_description", unique: true
    t.index ["table_size"], name: "index_table_sizes_on_table_size", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", null: false
    t.string "encrypted_password", limit: 128, null: false
    t.string "confirmation_token", limit: 128
    t.string "remember_token", limit: 128, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email"
    t.index ["remember_token"], name: "index_users_on_remember_token", unique: true
  end

  create_table "villain_hands", force: :cascade do |t|
    t.bigint "hand_history_id"
    t.bigint "hand_id"
    t.index ["hand_history_id"], name: "index_villain_hands_on_hand_history_id"
    t.index ["hand_id"], name: "index_villain_hands_on_hand_id"
  end

  add_foreign_key "game_types", "bet_structures"
  add_foreign_key "game_types", "poker_variants"
  add_foreign_key "game_types", "stakes"
  add_foreign_key "hand_histories", "bet_sizes"
  add_foreign_key "hand_histories", "hands"
  add_foreign_key "hand_histories", "poker_sessions"
  add_foreign_key "hand_histories", "positions"
  add_foreign_key "hand_histories", "table_sizes"
  add_foreign_key "poker_sessions", "game_types"
  add_foreign_key "shared_hand_histories", "hand_histories"
  add_foreign_key "villain_hands", "hand_histories"
  add_foreign_key "villain_hands", "hands"
end
