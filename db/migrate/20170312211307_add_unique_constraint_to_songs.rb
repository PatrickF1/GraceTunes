class AddUniqueConstraintToSongs < ActiveRecord::Migration
  def change
    add_index :songs, [:name, :artist, :tempo], unique: true
  end

end
