class AddSpotifyUriToSongs < ActiveRecord::Migration[5.1]
  def change
    add_column :songs, :spotify_uri, :string
    # initialize the new column to be empty string so that the
    # fill_in_spotify_uris Rake task will process them
    Song.update_all spotify_uri: ''
  end
end
