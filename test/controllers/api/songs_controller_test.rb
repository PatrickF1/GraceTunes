require_relative 'api_controller_test_base'
class API::SongsControllerTest < API::ControllerTestBase

  test "index should require user to be signed in" do
    sign_out
    get :index
    assert_response :forbidden
  end

  test "index should respect page_size param" do
    get :index, params: {page_size: 1}
    decode_songs
    assert_equal(@songs.size, 1)
  end

  test "index should return songs most relevant to query when no sort_by" do
    get :index, params: { query: "hand", page_size: 2 }
    decode_songs
    assert_equal([songs(:hands_to_the_heaven), songs(:glorious_day)], @songs)
  end

  test "index sort_by: created_at should return newest songs first" do
    get :index, params: {sort_by: :created_at, page_size: 3}
    decode_songs
    assert_equal([songs(:God_be_praised), songs(:forever_reign), songs(:ten_thousand_reasons)], @songs)
  end

  test "show 404s if no song by id" do
    get :show, params: {id: -1}
    assert_response :not_found
  end

  test "show sheet_format: no_chords removes chords" do
    song = songs(:God_be_praised)
    get :show, params: {id: song.id, sheet_format: :no_chords}
    decode_song
    Formatter.format_song_no_chords(song)
    assert_equal(song, @song)
  end

  test "readers should not be allowed to create or update songs" do
    song = songs(:God_be_praised)
    post :update, params: { song: song.as_json, id: song.id }
    assert_response :forbidden

    post :create, params: { song: song.as_json }
    assert_response :forbidden
  end

  test "non-admins should not be able to delete songs" do
    assert_no_difference("Song.count") do
      delete :destroy, params: { id: songs(:forever_reign).id }
    end

    assert_response :forbidden
  end

  private
  def decode_songs
    assert_response :ok
    @songs = @response.parsed_body['data'].map do |s|
      Song.new(s.except('spotify_widget_source'))
    end
  end

  def decode_song
    assert_response :ok
    @song = Song.new(@response.parsed_body.except('spotify_widget_source'))
  end

end
