# this migration will fail on databases that already contain songs
class AddLyricsColumnToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :lyrics, :text, null: false, after: :chord_sheet

    # for the purposes of full-text search, need to reindex
    remove_index :songs, column: :chord_sheet
    add_index :songs, :lyrics, using: :gin
  end
end
