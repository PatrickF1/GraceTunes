require 'test_helper'

class SongsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "index should retrieve relevant search results" do
    get :index, sSearch: 'hand', format: :json, xhr: true
    songs = JSON.parse(@response.body)['data']
    assert_equal(songs.length, 2)
  end

  test "should get new" do
    get :new
    assert_response :success
  end
end
