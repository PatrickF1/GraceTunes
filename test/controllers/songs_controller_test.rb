require "test_helper"

class SongsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "index should retrieve relevant keyword search results" do
    get :index, search: { value: "hand" }, format: :json, xhr: true

    songs_data = load_songs

    assert_includes(songs_data, songs(:hands_to_the_heaven))
    assert_includes(songs_data, songs(:glorious_day))
  end

  test "index should stack searches" do
    http_params = {
      search: { value: "forever" },
      tempo: "Medium",
      key: "B",
      format: :json,
      xhr: :true
    }

    get :index, http_params
    songs_data = load_songs

    # these songs almost match but have different keys
    assert(songs_data.exclude?(songs(:all_my_hope)))
    assert(songs_data.exclude?(songs(:ten_thousand_reasons)))
    assert(songs_data.exclude?(songs(:forever_reign)))

    assert_includes(songs_data, songs(:glorious_day))
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  private
  def load_songs
    JSON.parse(@response.body)["data"].map do |s|
      s.delete('relevance')
      Song.new(s)
    end
  end

end
