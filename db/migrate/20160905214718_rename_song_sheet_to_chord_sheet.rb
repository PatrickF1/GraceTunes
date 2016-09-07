class RenameSongSheetToChordSheet < ActiveRecord::Migration
  def change
    rename_column :songs, :song_sheet, :chord_sheet
  end
end
