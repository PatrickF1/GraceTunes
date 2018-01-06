class AddSpotifyUriToSongs < ActiveRecord::Migration[5.1]
  def change
    add_column :songs, :spotify_uri, :string
  end
end
