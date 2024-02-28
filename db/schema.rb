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

ActiveRecord::Schema[7.1].define(version: 2024_02_19_202443) do
  create_schema "heroku_ext"

  # These are extensions that must be enabled in order to support this database
  enable_extension "btree_gin"
  enable_extension "pg_stat_statements"
  enable_extension "plpgsql"

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.string "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.jsonb "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at", precision: nil
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "praise_sets", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "owner_email", null: false
    t.string "event_name", null: false
    t.date "event_date", null: false
    t.text "notes"
    t.boolean "archived", null: false
    t.jsonb "praise_set_songs", default: []
    t.index ["event_date"], name: "index_praise_sets_on_event_date"
    t.index ["owner_email"], name: "index_praise_sets_on_owner_email"
  end

  create_table "song_deletion_records", id: :bigint, default: nil, force: :cascade do |t|
    t.datetime "deleted_at", precision: nil, null: false
    t.string "name", null: false
  end

  create_table "songs", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "name", null: false
    t.string "key", null: false
    t.string "tempo", null: false
    t.string "artist"
    t.string "standard_scan"
    t.text "chord_sheet", null: false
    t.text "lyrics", null: false
    t.string "spotify_uri"
    t.integer "bpm"
    t.integer "view_count", default: 0, null: false
    t.index ["artist"], name: "index_songs_on_artist", using: :gin
    t.index ["lyrics"], name: "index_songs_on_lyrics", using: :gin
    t.index ["name", "artist"], name: "index_songs_on_name_and_artist", unique: true
    t.index ["name"], name: "index_songs_on_name", using: :gin
    t.check_constraint "bpm >= 1 AND bpm <= 1000", name: "is_valid_bpm"
    t.check_constraint "view_count >= 0", name: "view_count_gte_zero"
  end

  create_table "users", primary_key: "email", id: :string, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "name", null: false
    t.string "role", null: false
  end

  add_foreign_key "praise_sets", "users", column: "owner_email", primary_key: "email"
end
