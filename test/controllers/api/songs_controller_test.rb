require 'test_helper'
require_relative 'api_controller_test.rb'

class API::SongsControllerTest < API::APIControllerTest

  test 'recently_updated should retrieve only songs updated after date specified' do
    updated_since_value = "2019-01-01 00:00:00"

    get :recently_updated, params: {updated_since: updated_since_value}
    assert_response :success

    songs_json_object = JSON.parse(@response.body)
    songs_json_object.map do |song_json|
      assert(song_json['updated_at'] > updated_since_value)
    end
    assert(
      songs_json_object.count == 4,
      "Expecting exactly the song fixtures relevant[1-4] to have been updated since #{updated_since_value}"
    )
  end

  test 'recently_updated should retrieve all songs if no date specified' do
    get :recently_updated
    assert_response :success
    assert(JSON.parse(@response.body).count == 12, "Expecting all 12 song fixtures to be returned")
  end

  test 'recently_updated should not be accessible without correct HTTP auth headers' do
    clear_auth_headers
    get :recently_updated
    assert_response :unauthorized
  end

end