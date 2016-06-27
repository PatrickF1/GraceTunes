class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :name, null: false
      t.string :key, :limit => 2
      t.string :artist
      t.text   :song_sheet

      t.timestamps null: false
    end

    add_index :songs, :name
    add_index :songs, :artist
  end
end
