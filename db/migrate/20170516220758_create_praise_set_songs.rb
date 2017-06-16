class CreatePraiseSetSongs < ActiveRecord::Migration[5.1]
  def change
    create_table :praise_set_songs do |t|
      t.references :praise_set
      t.references :song
    end

    add_index :praise_set_songs, :praise_set_id
    add_index :praise_set_songs, :song_id
  end
end
