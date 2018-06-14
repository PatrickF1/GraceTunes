class CreateDeletedSongs < ActiveRecord::Migration[5.1]
  def change
    create_table :deleted_songs do |t|
      t.datetime "deleted_at", null: false
      t.string "name", null: false
    end
  end
end
