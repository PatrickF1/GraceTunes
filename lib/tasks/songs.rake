require 'net/http'
require 'json'

# Turns off record_timestamps temporarily so that the updated_at field
# will not be touched. Preserves current order of songs.
def defragment_ids
  begin
    ActiveRecord::Base.record_timestamps = false
    current_id = 1
    # find_each retrives songs in order of "id ASC"
    Song.find_each do |song|
      song.id = current_id
      song.save!
      current_id += 1
    end
  ensure
    ActiveRecord::Base.record_timestamps = true
  end
end

def generate_spotify_search_request(song, token)
  q_query_param = "track:\"#{song.name}\""
  q_query_param += "+artist:\"#{song.artist}\"" if song.artist.present?

  params = {
    q: q_query_param,
    market: "US",
    type: "track",
    limit: 1
  }
  uri = URI('https://api.spotify.com/v1/search')
  uri.query = URI.encode_www_form(params)
  req = Net::HTTP::Get.new(uri)
  req['Authorization'] = "Bearer #{token}"
  req
end

# For all songs on GraceTunes without a Spotify URI, searches Spotify for
# a song with the same name and artist and fills in Spotify URI
# with the first match found.
def fill_in_spotify_uris(token)
  abort("Must provide Spotify access token.") if token.nil?

  Net::HTTP.start("api.spotify.com", use_ssl: true) do |http|
    Song.where(spotify_uri: nil).find_each do |song|
      request = generate_spotify_search_request(song, token)
      # byebug
      response = http.request(request)
      if response.instance_of? Net::HTTPOK
        resp_body_json = JSON.parse(response.body)
        if matching_track_uri = resp_body_json.dig("tracks", "items", 0, "uri")
          song.spotify_uri = matching_track_uri
          song.save!
          puts "Found a matching Spotify track for #{song}"
        else
          puts "No matching Spotify track for #{song}"
        end
      elsif response.instance_of? Net::HTTPUnauthorized
        abort("Invalid Spotify access token provided.")
      else
        abort("Unexpected response while querying Spotify API: #{response.message}")
      end
    end
  end
end

# Removes Spotify URIs that are broken
def clean_up_broken_spotify_uris

end

namespace :songs do
  desc 'Defragment song ids so that the lowest id starts at 1 and there are no gaps.'
  task :defrag_ids  => :environment do |t, args|
    defragment_ids()
  end

  desc "Attempt to fill in blank Spotify URIs."
  task :fill_in_spotify_uris, [:token] => :environment do |t, args|
    fill_in_spotify_uris(args.token)
  end

end