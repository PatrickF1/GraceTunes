class CreateSongsAndTags < ActiveRecord::Migration

  def change
   

    add_index :songs, :name
    add_index :songs, :artist

    create_table :tags do |t|
      t.string :name, null: false
      t.timestamps null: false
    end

    create_table :song_tags do |t|
      t.references :song
      t.references :tag
      t.timestamps null: false
    end

    add_index :song_tags, :song
    add_index :song_tags, :tag
  end
end
