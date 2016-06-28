# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160627064700) do

  create_table "song_tags", force: :cascade do |t|
    t.integer  "song_id",    limit: 4
    t.integer  "tag_id",     limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "song_tags", ["song_id"], name: "index_song_tags_on_song_id", using: :btree
  add_index "song_tags", ["tag_id"], name: "index_song_tags_on_tag_id", using: :btree

  create_table "songs", force: :cascade do |t|
    t.string   "name",       limit: 255,   null: false
    t.string   "key",        limit: 2
    t.string   "artist",     limit: 255
    t.text     "song_sheet", limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "songs", ["artist"], name: "index_songs_on_artist", using: :btree
  add_index "songs", ["name"], name: "index_songs_on_name", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

end
