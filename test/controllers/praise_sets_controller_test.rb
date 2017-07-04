require "test_helper"
require_relative 'application_controller_test.rb'

class PraiseSetsControllerTest < ApplicationControllerTest

  test "index should be retrieved successfully" do
    get :index
    assert_response :success
  end

  test "index should sort praise sets by event date" do
    get :index

    assigns(:praise_sets).each_with_index do |praise_set, index|
      if index < assigns(:praise_sets).size - 1
        assert praise_set.event_date > assigns(:praise_sets)[index+1].event_date
      end
    end
  end

  test "new praise set page should load successfully for normal users" do
    get :new
    assert_response :success
  end

  test "should load the new praise set template when praise set creation unsuccessful" do
    post :create, params: { praise_set: { problem: true } }
    assert_template :new
  end

  test "should show error messages when praise set creation unsuccessful" do
    post :create, params: { praise_set: { problem: true } }
    assert_select ".praise-set-errors", true, "Error messages did not appear"
  end

  test "submitting a valid praise set should result in a new praise set in the database" do
    assert_difference('PraiseSet.count', difference = 1) do
      post_new_praise_set
    end
    assert_not_nil PraiseSet.find_by_event_name("New Praise Set")
  end

  test "after creating a new praise set should redirect to it's edit praise set page" do
    post_new_praise_set
    assert_redirected_to edit_praise_set_path(assigns(:praise_set))
  end

  test "edit praise set page should load successfully if logged in as any user" do
    get :edit, params: { id: praise_sets(:relevant_songs).id }
    assert_response :success
  end

  test "should notify user appropriately when praise set created successfully" do
    post_new_praise_set
    assert_not_nil flash[:success]
  end

  test "updating a praise set should result in the song having a different event_name in the DB" do
    new_praise_set_name = "Newer Praise Set!!"
    praise_set = praise_sets(:hillsong)
    praise_set.event_name = new_praise_set_name
    update_praise_set(praise_set)

    updated_praise_set = PraiseSet.find(praise_set.id)
    assert_equal updated_praise_set.event_name, new_praise_set_name
  end

  test "after editing a praise set should redirect to its edit page" do
    praise_set = praise_sets(:hillsong)
    update_praise_set(praise_set)
    assert_redirected_to edit_praise_set_path(praise_set)
  end

  test "add_song should add a song to the praise set songs" do
    praise_set = praise_sets(:hillsong)
    assert_difference('PraiseSet.find(praise_set.id).songs.size', difference = 1) do
      put :add_song, params: {
        id: praise_set.id,
        song_id: songs(:God_be_praised).id
      }
    end
  end

  test "add_song should return the praise_set_song partial if xhr" do
    praise_set = praise_sets(:hillsong)
    put :add_song, xhr: true,  params: {
      id: praise_set.id,
      song_id: songs(:God_be_praised).id
    }
    assert_template partial: "_praise_set_song"
  end

  test "remove_song should remove a song from the praise set songs" do
    praise_set = praise_sets(:hillsong)
    assert_difference('PraiseSet.find(praise_set.id).songs.size', difference = -1) do
      put :remove_song, params: {
        id: praise_set.id,
        song_id: songs(:forever_reign).id
      }
    end
  end

  test "remove_song should render the json of the removed song" do
    praise_set = praise_sets(:hillsong)
    put :remove_song, params: {
      id: praise_set.id,
      song_id: songs(:forever_reign).id
    }
    assert_equal songs(:forever_reign).id, JSON.parse(@response.body)[0]["id"]
  end

  private
  def post_new_praise_set
    post :create, params: {
      praise_set: {
        owner_email: "admin@gpmail.org",
        event_name: "New Praise Set",
        event_date: "2017-07-01",
        notes: "This is a new praise set"
      }
    }
  end

  def update_praise_set(praise_set)
    post :update, params: {
      praise_set: praise_set.as_json,
      id: praise_set.id
    }
  end
end