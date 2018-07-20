class CreateSongDeletionRecords < ActiveRecord::Migration[5.1]
  def up
    create_table :song_deletion_records do |t|
      t.datetime "deleted_at", null: false
      t.string "name", null: false
    end
    change_column_default :song_deletion_records, :id, nil
  end

  def down
    drop_table :song_deletion_records
  end
end
