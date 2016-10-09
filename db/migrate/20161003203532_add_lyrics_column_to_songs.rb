# this migration will fail on databases that already contain songs
class AddLyricsColumnToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :lyrics, :text, null: false, after: :chord_sheet
  end
end
