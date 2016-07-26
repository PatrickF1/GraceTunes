require "test_helper"

class SongsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "index should retrieve relevant search results" do
    get :index, sSearch: "hand", format: :json, xhr: true

    songs_data = JSON.parse(@response.body)["data"].map! do|s|
      s.delete('relevance')
      Song.new(s)
    end

    assert_includes(songs_data, songs(:hands_to_the_heaven))
    assert_includes(songs_data, songs(:glorious_day))
  end

  test "should get new" do
    get :new
    assert_response :success
  end

end
