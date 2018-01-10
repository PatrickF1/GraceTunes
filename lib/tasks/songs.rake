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

# generates a request to this API endpoint
# https://developer.spotify.com/web-api/search-item/
def generate_spotify_search_request(song, token)
  q_query_param = %Q(track:"#{song.name}")
  if song.artist.present?
    q_query_param << %Q(+artist:"#{song.artist}")
  else
    puts "! WARNING: no artist provided for #{song}. Spotify may return an invalid song."
  end

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
# a song with the same name and artist and fills in the Spotify URI field
# with the first match found. Very strict in that name and artist must match
# exactly in order to lower the risk of adding unholy songs to GraceTunes.
def fill_in_spotify_uris(token)
  abort("Must provide Spotify access token.") if token.nil?

  Net::HTTP.start("api.spotify.com", use_ssl: true) do |http|
    Song.where(spotify_uri: nil).find_each do |song|
      request = generate_spotify_search_request(song, token)
      response = http.request(request)
      if response.instance_of? Net::HTTPOK
        resp_body_json = JSON.parse(response.body)
        if matching_track = resp_body_json.dig("tracks", "items", 0)
          if matching_track["explicit"]
            puts "! WARNING: explicit Spotify track found for #{song}. Not filling in!"
          else
            song.spotify_uri = matching_track["uri"]
            song.save!
            puts "\u2713 Matching Spotify track found for #{song}."
          end
        else
          puts "\u2718 No matching Spotify track for #{song}."
        end
      elsif response.instance_of? Net::HTTPUnauthorized
        abort("Invalid Spotify access token provided.")
      elsif response.instance_of? Net::HTTPTooManyRequests
        wait_time_seconds = response['Retry-After'].to_i
        puts "! Too many requests, pausing for #{wait_time_seconds} seconds"
        sleep wait_time_seconds
        redo
      else
        abort("Unexpected response while querying Spotify API: #{response.message}")
      end
    end
  end
end

def remove_broken_spotify_uris
  Net::HTTP.start("open.spotify.com", use_ssl: true) do |http|
    Song.where.not(spotify_uri: nil).find_each do |song|
      widget_source = URI(song.spotify_widget_source)
      request = Net::HTTP::Get.new(widget_source)
      response = http.request(request)
      if response.instance_of? Net::HTTPNotFound
        song.spotify_uri = nil
        song.save!
        puts "\u2326 Removed broken Spotify URI for #{song}."
      elsif !response.instance_of? Net::HTTPOK
        abort("Unexpected response opening link: #{response.message}")
      end
    end
  end
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

  desc "Find and remove broken Spotify URIs."
  task :remove_broken_spotify_uris => :environment do |t, args|
    remove_broken_spotify_uris()
  end

end