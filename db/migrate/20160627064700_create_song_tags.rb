class CreateSongTags < ActiveRecord::Migration
  def change
    create_table :song_tags do |t|
      t.references :song
      t.references :tag

      t.timestamps null: false
    end

    add_index :song_tags, :song
    add_index :song_tags, :tag
  end
end
