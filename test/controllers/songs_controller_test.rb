# frozen_string_literal: true

require "test_helper"
require_relative 'application_controller_test'

class SongsControllerTest < ApplicationControllerTest
  # "index" action tests
  test "index should require user to be signed in" do
    sign_out
    get :index
    assert_redirected_to sign_in_path
  end

  test "index should return songs by alphabetical order when sorting by relevance and there is no search value" do
    get :index, params: {
      sort: :relevance,
      format: :json,
      xhr: true
    }

    songs_data = load_songs

    assert_equal(songs(:ten_thousand_reasons), songs_data[0])
    assert_equal(songs(:all_my_hope), songs_data[1])
  end

  test "index should be able to return songs ordered by view count" do
    get :index, params: {
      sort: 'Most Popular First',
      format: :json,
      xhr: true
    }

    songs_data = load_songs

    assert_equal(songs(:glorious_day), songs_data[0])
    assert_equal(songs(:God_be_praised), songs_data[1])
  end

  test "index should be able to return songs ordered by date created" do
    get :index, params: {
      sort: 'Newest First',
      format: :json,
      xhr: true
    }

    songs_data = load_songs

    assert_equal(songs(:God_be_praised), songs_data[0])
    assert_equal(songs(:forever_reign), songs_data[1])
    assert_equal(songs(:ten_thousand_reasons), songs_data[2])
  end

  test "index should return results relevant to the search value" do
    get :index, params: {
      search: { value: "hand" },
      format: :json,
      xhr: true
    }

    songs_data = load_songs

    assert_includes(songs_data, songs(:hands_to_the_heaven))
    assert_includes(songs_data, songs(:glorious_day))
  end

  test "index should be able to combine filters, sorting, and search values" do
    rare_keyword = 'ymmv'
    key = "Db"
    tempo = "Fast"

    # create songs to be expected in results
    Song.create!(
      name: "1",
      artist: "A",
      key:,
      tempo:,
      chord_sheet: ([rare_keyword] * 5).join(" "),
      view_count: 1
    )
    Song.create!(
      name: "2",
      artist: "A",
      key:,
      tempo:,
      chord_sheet: ([rare_keyword] * 2).join(" "),
      view_count: 3
    )
    Song.create!(
      name: "3",
      artist: "A",
      key:,
      tempo:,
      chord_sheet: ([rare_keyword] * 8).join(" "),
      view_count: 2
    )
    Song.create!(
      name: "4",
      artist: "A",
      key:,
      tempo:,
      chord_sheet: rare_keyword,
      view_count: 4
    )

    # create songs not to be expected in results
    Song.create!(
      name: "5",
      artist: "A",
      key:,
      tempo: "Medium",
      chord_sheet: rare_keyword
    )
    Song.create!(
      name: "6",
      artist: "A",
      key: "B",
      tempo:,
      chord_sheet: rare_keyword
    )
    Song.create!(
      name: "7",
      artist: "A",
      key:,
      tempo:,
      chord_sheet: "nothing"
    )

    get :index, params: {
      search: { value: rare_keyword },
      tempo:,
      key:,
      sort: 'Most Popular First',
      format: :json,
      xhr: true
    }

    songs_data = load_songs

    assert_equal(4, songs_data.length)
    assert_equal("4", songs_data[0].name)
    assert_equal("2", songs_data[1].name)
    assert_equal("3", songs_data[2].name)
  end

  # "show" action tests
  test "show song page should display the standard scan when it is not blank" do
    get :show, params: { id: songs(:forever_reign).id }
    assert_select ".song-metadata", /Standard Scan:/, "Standard scan should appear if it is not blank"
  end

  test "show song page should not display the standard scan when it is blank" do
    get :show, params: { id: songs(:glorious_day).id }
    assert_select ".song-metadata", {text: /Standard Scan:/, count: 0},
                  "Standard scan should not appear if it is blank"
  end

  test "visiting the show song page causes the song's view count to increment" do
    forever_reign_id = songs(:forever_reign).id
    assert_difference("Song.find(#{forever_reign_id}).view_count", 1) do
      get :show, params: { id: forever_reign_id }
    end
  end

  # "new" action tests
  test "new song page should load successfully if logged in as praise member" do
    get_edit_privileges
    get :new
    assert_response :success
  end

  test "readers should be redirected to songs index if they try to access the new song page" do
    get :new
    assert_redirected_to songs_path
  end

  # "create" action tests
  test "should load the new song template when song creation unsuccessful" do
    get_edit_privileges
    post :create, params: { song: { problem: true } }
    assert_template :new
  end

  test "should show error messages when song creation unsuccessful" do
    get_edit_privileges
    post :create, params: { song: { problem: true } }
    assert_select ".song-errors", true, "Error messages did not appear when song creation failed"
  end

  test "submitting a valid song should result in a new song in the database with the same name" do
    get_edit_privileges
    assert_difference('Song.count', 1) do
      post_new_song_form
    end
    assert_not_nil Song.find_by(name: "New Song Just Posted")
  end

  test "after creating a new song should redirect to its show song page" do
    get_edit_privileges
    post_new_song_form
    assert_redirected_to song_path(assigns(:song))
  end

  test "should notify user appropriately when song created successfully" do
    get_edit_privileges
    post_new_song_form
    assert_not_nil flash[:success]
  end

  test "readers should be redirected to songs index if they try to create" do
    post_new_song_form
    assert_redirected_to songs_path
  end

  # "update" action tests
  test "updating a song should result in the song having a different name in the DB" do
    get_edit_privileges
    new_song_name = "Newer Song Just Updated"

    song = songs(:God_be_praised)
    song.name = new_song_name
    post :update, params: {
      song: song.as_json,
      id: song.id
    }

    updated_song = Song.find_by(name: new_song_name)
    assert_equal updated_song.id, song.id
  end

  test "after editing a song should redirect to its show song page" do
    get_edit_privileges
    song = songs(:God_be_praised)
    post :update, params: {
      song: song.as_json,
      id: song.id
    }
    assert_redirected_to song_path(song)
  end

  test "readers should be directed to songs index if they try to update a song" do
    song = songs(:God_be_praised)
    post :update, params: { song: song.as_json, id: song.id }
    assert_redirected_to songs_path
  end

  # "edit" action tests
  test "edit song page should load successfully if logged in as praise member" do
    get_edit_privileges
    get :edit, params: { id: songs(:forever_reign).id }
    assert_response :success
  end

  test "readers should be redirected to songs index if they try to access the edit song page" do
    get :edit, params: { id: songs(:forever_reign).id }
    assert_redirected_to songs_path
  end

  # "destroy" action tests
  test "admins should be able to delete songs" do
    get_deleting_privileges

    assert_difference("Song.count", -1) do
      delete :destroy, params: { id: songs(:forever_reign).id }
    end

    assert_redirected_to songs_path
  end

  test "non-admins should not be able to delete songs" do
    assert_no_difference("Song.count") do
      delete :destroy, params: { id: songs(:forever_reign).id }
    end

    assert_redirected_to songs_path
  end

  test "the id, name, and timestamp of deletion is recorded when destroying a song" do
    get_deleting_privileges

    song = songs(:forever_reign)
    delete :destroy, params: { id: song.id }
    assert_response :found
    record = SongDeletionRecord.find(song.id)

    assert_equal(record.id, song.id)
    assert_equal(record.name, song.name)
  end

  # "print" action tests
  test "the standard scan field should not appear if it is blank" do
    get :print, params: { id: songs(:glorious_day).id }
    assert_select ".standard-scan", false, "Standard scan should not appear if it is blank"
  end

  private

  def load_songs
    JSON.parse(@response.body)["data"].map do |s|
      s.delete('relevance')
      s.delete('spotify_widget_source')
      Song.new(s)
    end
  end

  def post_new_song_form
    post :create, params: {
      song: {
        name: "New Song Just Posted",
        key: "E",
        artist: "New Song Artist",
        tempo: "Fast",
        chord_sheet: "New Song Chords"
      }
    }
  end
end
