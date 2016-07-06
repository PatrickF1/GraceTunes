class MoveArtistColumn < ActiveRecord::Migration
  def change
    change_column :songs, :artist, :string, after: "name"
  end
end
