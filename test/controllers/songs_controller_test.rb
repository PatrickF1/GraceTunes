require "test_helper"

class SongsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "index should retrieve relevant search results" do
    get :index, sSearch: "hand", format: :json, xhr: true
    songs = JSON.parse(@response.body)["data"]
    song_names = songs.map { |s| s["name"] }
    assert_includes(song_names, songs(:hands_to_the_heaven)[:name])
    assert_includes(song_names, songs(:glorious_day)[:name])
  end

  test "should get new" do
    get :new
    assert_response :success
  end

end
