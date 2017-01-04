class ReorderSongsColumns < ActiveRecord::Migration
  def change
    drop_table :songs
    # associated indexes automatically removed?

    create_table "songs", force: :cascade do |t|
      t.datetime "created_at",    null: false
      t.datetime "updated_at",    null: false
      t.string   "name",          null: false
      t.string   "key",           null: false
      t.string   "tempo",         null: false
      t.string   "artist"
      t.string   "standard_scan"
      t.text     "chord_sheet",   null: false
      t.text     "lyrics",        null: false
    end

    # readd columns
  end
end
