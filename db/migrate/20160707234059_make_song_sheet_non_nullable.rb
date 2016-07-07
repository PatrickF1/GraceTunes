class MakeSongSheetNonNullable < ActiveRecord::Migration
  def change
    change_column :songs, :song_sheet, :text, null: false
  end
end
