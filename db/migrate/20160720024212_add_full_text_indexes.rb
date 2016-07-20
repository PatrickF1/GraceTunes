class AddFullTextIndexes < ActiveRecord::Migration
  def change
    # remove indexes 
    remove_index :songs, column: :name

    # add indexes needed for full text search
    add_index :songs, :name, type: :fulltext
    add_index :songs, :song_sheet, type: :fulltext
    add_index :songs, [:name, :song_sheet], type: :fulltext
  end
end
