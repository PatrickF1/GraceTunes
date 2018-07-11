class CreateDeletedSongs < ActiveRecord::Migration[5.1]
  def up
    create_table :deleted_songs do |t|
      t.datetime "deleted_at", null: false
      t.string "name", null: false
    end
    change_column_default :deleted_songs, :id, nil
  end

  def down
    drop_table :deleted_songs
  end
end
