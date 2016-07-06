class AddTempoToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :tempo, :string, after: "artist"
  end
end
