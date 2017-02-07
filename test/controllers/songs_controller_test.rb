require "test_helper"
require_relative 'application_controller_test.rb'

class SongsControllerTest < ApplicationControllerTest

  # "index" action tests
  test "index should be retrieved successfully" do
    get :index
    assert_response :success
  end

  test "index should retrieve relevant keyword search results" do
    get :index, search: { value: "hand" }, format: :json, xhr: true

    songs_data = load_songs

    assert_includes(songs_data, songs(:hands_to_the_heaven))
    assert_includes(songs_data, songs(:glorious_day))
  end

  test "index should stack filters" do
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

  # "new" action tests
  test "new song page should load successfully" do
    get :new
    assert_response :success
  end

  # "create" action tests
  test "should load the new song template when song creation unsuccessful" do
    post :create, song: {problem: true}
    assert_template :new
  end

  test "submitting a valid song should result in a new song in the database with the same name" do
    assert_difference('Song.count', difference = 1) do
      post_new_song_form
    end
    assert_not_nil Song.find_by_name("New Song Just Posted")
  end

  test "should redirect to index when song successfully created" do
    post_new_song_form
    # TODO: will redirect to show action once it's implemented
    assert_redirected_to action: "index"
  end

  test "should notify user appropriately when song created successfully" do
    post_new_song_form
    assert_not_nil flash[:success]
  end

  test "editing a song should result in the song in the database with a different name" do
    new_song_name = "Newer Song Just Updated"

    song = songs(:God_be_praised)
    song.name = new_song_name
    patch :update, song: song.as_json, id: song.id

    updated_song = Song.find_by_name(new_song_name)
    assert_equal updated_song.id, song.id
  end

  test "the standard scan field should not appear if it is blank" do
    get :print, id: songs(:relevant_1).id
    assert_select ".standard-scan", false, "Standard scan should not appear if it is blank"
  end

  private
  def load_songs
    JSON.parse(@response.body)["data"].map do |s|
      s.delete('relevance')
      Song.new(s)
    end
  end

  def post_new_song_form
    post :create, song: {
      name: "New Song Just Posted",
      key: "E",
      artist: "New Song Artist",
      tempo: "Fast",
      chord_sheet: "New Song Chords"
    }
  end

end
