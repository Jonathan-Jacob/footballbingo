# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_03_02_113822) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bingo_cards", force: :cascade do |t|
    t.bigint "game_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["game_id"], name: "index_bingo_cards_on_game_id"
    t.index ["user_id"], name: "index_bingo_cards_on_user_id"
  end

  create_table "bingo_tiles", force: :cascade do |t|
    t.text "action"
    t.string "status"
    t.bigint "bingo_card_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["bingo_card_id"], name: "index_bingo_tiles_on_bingo_card_id"
  end

  create_table "games", force: :cascade do |t|
    t.bigint "match_id", null: false
    t.bigint "group_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id"], name: "index_games_on_group_id"
    t.index ["match_id"], name: "index_games_on_match_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_groups_on_user_id"
  end

  create_table "match_events", force: :cascade do |t|
    t.text "action"
    t.bigint "match_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["match_id"], name: "index_match_events_on_match_id"
  end

  create_table "matches", force: :cascade do |t|
    t.time "date_time"
    t.string "status"
    t.string "team_1"
    t.string "team_2"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "nickname"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_groups", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "group_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id"], name: "index_users_groups_on_group_id"
    t.index ["user_id"], name: "index_users_groups_on_user_id"
  end

  add_foreign_key "bingo_cards", "games"
  add_foreign_key "bingo_cards", "users"
  add_foreign_key "bingo_tiles", "bingo_cards"
  add_foreign_key "games", "groups"
  add_foreign_key "games", "matches"
  add_foreign_key "groups", "users"
  add_foreign_key "match_events", "matches"
  add_foreign_key "users_groups", "groups"
  add_foreign_key "users_groups", "users"
end
