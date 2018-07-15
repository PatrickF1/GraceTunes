require 'test_helper'
require_relative 'api_controller_test.rb'

class API::SongsControllerTest < API::APIControllerTest

  test 'recently_updated should not be accessible without correct HTTP auth headers' do
    clear_auth_headers
    get :recently_updated
    assert_response :unauthorized
  end

  test 'recently_updated should retrieve all songs if no date is specified' do
    get :recently_updated
    assert_response :success
    assert(JSON.parse(@response.body).count == 12, "Expecting all 12 song fixtures to be returned")
  end

  test 'recently_updated should retrieve only the songs updated on or after the date specified' do
    updated_since_value = "2019-01-01 00:00:00"

    get :recently_updated, params: {updated_since: updated_since_value}
    assert_response :success

    songs_json_object = JSON.parse(@response.body)
    songs_json_object.map do |song_json|
      assert(song_json['updated_at'] >= updated_since_value)
    end
    assert(
      songs_json_object.count == 4,
      "Expecting exactly the song fixtures relevant[1-4] to have been updated since #{updated_since_value}"
    )
  end

  test 'deleted should not be accessible without correct HTTP auth headers' do
    clear_auth_headers
    get :deleted
    assert_response :unauthorized
  end

  test 'deleted should retrieve information on all deleted songs if no date is specified' do
    get :deleted
    assert_response :success
    assert(JSON.parse(@response.body).count == 4, "Expecting all 4 deleted song fixtures to be returned")
  end

  test 'deleted should retrieve information on deleted songs after the date specified' do
    deleted_since_value = "2018-07-01"

    get :deleted, params: {since: deleted_since_value}
    assert_response :success
    response_body = JSON.parse(@response.body)
    assert(response_body.count == 1, "Only lion_and_the_lamb was deleted after #{deleted_since_value}}")
    assert_equal(deleted_songs(:lion_and_the_lamb), DeletedSong.new(response_body[0]))

  end

end