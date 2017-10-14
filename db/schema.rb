# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170630201424) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "btree_gin"

  create_table "praise_set_songs", force: :cascade do |t|
    t.bigint "praise_set_id"
    t.bigint "song_id"
    t.integer "position", null: false
    t.string "key", null: false
    t.index ["praise_set_id"], name: "index_praise_set_songs_on_praise_set_id"
    t.index ["song_id"], name: "index_praise_set_songs_on_song_id"
  end

  create_table "praise_sets", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "owner_email", null: false
    t.string "event_name", null: false
    t.date "event_date", null: false
    t.text "notes"
    t.boolean "archived", null: false
    t.index ["event_date"], name: "index_praise_sets_on_event_date"
    t.index ["event_name"], name: "index_praise_sets_on_event_name"
    t.index ["owner_email"], name: "index_praise_sets_on_owner_email"
  end

  create_table "song_tags", id: :serial, force: :cascade do |t|
    t.integer "song_id"
    t.integer "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["song_id"], name: "index_song_tags_on_song_id"
    t.index ["tag_id"], name: "index_song_tags_on_tag_id"
  end

  create_table "songs", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.string "key", null: false
    t.string "tempo", null: false
    t.string "artist"
    t.string "standard_scan"
    t.text "chord_sheet", null: false
    t.text "lyrics", null: false
    t.index ["artist"], name: "index_songs_on_artist", using: :gin
    t.index ["lyrics"], name: "index_songs_on_lyrics", using: :gin
    t.index ["name", "artist"], name: "index_songs_on_name_and_artist", unique: true
    t.index ["name"], name: "index_songs_on_name", using: :gin
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", primary_key: "email", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.string "role", null: false
  end

end
