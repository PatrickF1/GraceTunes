class AddFullTextIndexes < ActiveRecord::Migration
  def change
    # remove indexes 
    remove_index :songs, column: :name
    remove_index :songs, column: :artist

    # add indexes needed for full text search
    add_index :songs, :name, using: :gin
    add_index :songs, :song_sheet, using: :gin
    add_index :songs, :artist, using: :gin
  end
end
