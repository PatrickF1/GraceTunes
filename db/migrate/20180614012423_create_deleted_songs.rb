class CreateDeletedSongs < ActiveRecord::Migration[5.1]
  def change
    create_table :deleted_songs, id: false do |t|
      t.integer "song_id", null: false
      t.datetime "deleted_at", null: false
      t.string "name", null: false
    end
  end
end
