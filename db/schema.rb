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

ActiveRecord::Schema.define(version: 2021_03_22_220311) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "bingo_cards", force: :cascade do |t|
    t.bigint "game_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "status", default: "not_started"
    t.index ["game_id"], name: "index_bingo_cards_on_game_id"
    t.index ["user_id"], name: "index_bingo_cards_on_user_id"
  end

  create_table "bingo_tiles", force: :cascade do |t|
    t.bigint "bingo_card_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "match_event_id", null: false
    t.integer "position"
    t.string "status", default: "unchecked"
    t.index ["bingo_card_id"], name: "index_bingo_tiles_on_bingo_card_id"
    t.index ["match_event_id"], name: "index_bingo_tiles_on_match_event_id"
  end

  create_table "chatrooms", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "competitions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "api_id"
    t.string "country"
  end

  create_table "games", force: :cascade do |t|
    t.bigint "match_id", null: false
    t.bigint "group_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "chatroom_id", null: false
    t.index ["chatroom_id"], name: "index_games_on_chatroom_id"
    t.index ["group_id"], name: "index_games_on_group_id"
    t.index ["match_id"], name: "index_games_on_match_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "chatroom_id", null: false
    t.index ["chatroom_id"], name: "index_groups_on_chatroom_id"
    t.index ["user_id"], name: "index_groups_on_user_id"
  end

  create_table "match_events", force: :cascade do |t|
    t.bigint "match_id", null: false
    t.string "action"
    t.string "agent"
    t.integer "amount"
    t.string "status", default: "not_happened"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["match_id"], name: "index_match_events_on_match_id"
  end

  create_table "matches", force: :cascade do |t|
    t.datetime "date_time"
    t.string "status", default: "not_started"
    t.string "team_1"
    t.string "team_2"
    t.json "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "competition_id", null: false
    t.integer "api_id"
    t.string "home_color", default: "#AAAAAA"
    t.string "away_color", default: "#AAAAAA"
    t.index ["competition_id"], name: "index_matches_on_competition_id"
  end

  create_table "messages", force: :cascade do |t|
    t.string "content"
    t.bigint "chatroom_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["chatroom_id"], name: "index_messages_on_chatroom_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "user_groups", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "group_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "status", default: "member"
    t.index ["group_id"], name: "index_user_groups_on_group_id"
    t.index ["user_id"], name: "index_user_groups_on_user_id"
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
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "winners", force: :cascade do |t|
    t.bigint "game_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["game_id"], name: "index_winners_on_game_id"
    t.index ["user_id"], name: "index_winners_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bingo_cards", "games"
  add_foreign_key "bingo_cards", "users"
  add_foreign_key "bingo_tiles", "bingo_cards"
  add_foreign_key "bingo_tiles", "match_events"
  add_foreign_key "games", "chatrooms"
  add_foreign_key "games", "groups"
  add_foreign_key "games", "matches"
  add_foreign_key "groups", "chatrooms"
  add_foreign_key "groups", "users"
  add_foreign_key "match_events", "matches"
  add_foreign_key "matches", "competitions"
  add_foreign_key "messages", "chatrooms"
  add_foreign_key "messages", "users"
  add_foreign_key "user_groups", "groups"
  add_foreign_key "user_groups", "users"
  add_foreign_key "winners", "games"
  add_foreign_key "winners", "users"
end
