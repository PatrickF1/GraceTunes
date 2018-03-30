require 'test_helper'
require_relative 'application_controller_test.rb'

class PraiseSetsControllerTest < ApplicationControllerTest

  test 'index should be retrieved successfully' do
    get :index
    assert_response :success
  end

  test 'index should sort praise sets by event date' do
    get :index
    assigns(:praise_sets).each_with_index do |praise_set, index|
      if index < assigns(:praise_sets).size - 1
        assert praise_set.event_date > assigns(:praise_sets)[index + 1].event_date
      end
    end
  end

  test 'index should only get praise sets user has access to' do
    get_relevant_set_owner # praise member
    get :index
    assert_equal 2, assigns(:praise_sets).size
  end

  test 'new praise set page should load successfully for normal users' do
    get :new
    assert_response :success
  end

  test 'show praise set should load successfully for owners of the praise set' do
    get_hillsong_set_owner
    get :show, params: { id: praise_sets(:hillsong).id }
    assert_response :success
  end

  test "users should be redirected to praise set index if they aren't the owner" do
    get :show, params: { id: praise_sets(:hillsong).id }
    assert_redirected_to praise_sets_path
  end

  test 'should load the new praise set template when praise set creation unsuccessful' do
    post :create, params: { praise_set: { problem: true } }
    assert_template :new
  end

  test 'should show error messages when praise set creation unsuccessful' do
    post :create, params: { praise_set: { problem: true } }
    assert_select '.praise-set-errors', true, 'Error messages did not appear'
  end

  test 'submitting a valid praise set should result in a new praise set in the database' do
    assert_difference('PraiseSet.count', difference = 1) do
      post_new_praise_set
    end
    assert_not_nil PraiseSet.find_by_event_name('New Praise Set')
  end

  test "after creating a new praise set should redirect to it's edit praise set page" do
    post_new_praise_set
    assert_redirected_to edit_praise_set_path(assigns(:praise_set))
  end

  test 'edit praise set page should load successfully if owner' do
    get_relevant_set_owner
    get :edit, params: { id: praise_sets(:relevant_songs).id }
    assert_response :success
  end

  test "users should be redirected to praise set index page if they aren't the owner" do
    get :edit, params: { id: praise_sets(:relevant_songs).id }
    assert_redirected_to praise_sets_path
  end

  test 'should notify user appropriately when praise set created successfully' do
    post_new_praise_set
    assert_not_nil flash[:success]
  end

  test 'updating a praise set should result in the song having a different event_name in the DB' do
    get_hillsong_set_owner
    new_praise_set_name = 'Newer Praise Set!!'
    praise_set = praise_sets(:hillsong)
    praise_set.event_name = new_praise_set_name
    update_praise_set(praise_set)
    updated_praise_set = PraiseSet.find(praise_set.id)
    assert_equal updated_praise_set.event_name, new_praise_set_name
  end

  test 'after editing a praise set should redirect to its edit page' do
    get_hillsong_set_owner
    praise_set = praise_sets(:hillsong)
    update_praise_set(praise_set)
    assert_redirected_to edit_praise_set_path(praise_set)
  end

  test 'updating a praise set song list should update the json, including order and keys' do
    get_hillsong_set_owner
    praise_set = praise_sets(:hillsong)
    praise_set.praise_set_songs = [
      { song_id: songs(:God_be_praised).id, song_key: "C" },
      { song_id: songs(:forever_reign).id, song_key: "B" } ]
    update_praise_set(praise_set)
    updated_praise_set = PraiseSet.find(praise_set.id)

    praise_set_song1 = songs(:God_be_praised)
    praise_set_song1.key = "C"
    praise_set_song2 = songs(:forever_reign)
    praise_set_song2.key = "B"

    assert_equal updated_praise_set.songs.first.attributes, praise_set_song1.attributes
    assert_equal updated_praise_set.songs.last.attributes, praise_set_song2.attributes
  end

  test 'archive praise_set should archive the praise_set' do
    get_relevant_set_owner
    praise_set = praise_sets(:relevant_songs)
    assert_changes 'PraiseSet.find(praise_set.id).archived', from: false, to: true do
      put :archive, params: {
        id: praise_set.id
      }
    end
  end

  test 'unarchive praise_set should unarchive the praise_set' do
    get_relevant_set_owner
    praise_set = praise_sets(:sws_05142017)
    assert_changes 'PraiseSet.find(praise_set.id).archived', from: true, to: false do
      put :unarchive, params: {
        id: praise_set.id
      }
    end
  end

  private

  def post_new_praise_set
    post :create, params: {
      praise_set: {
        owner_email: 'admin@gpmail.org',
        event_name: 'New Praise Set',
        event_date: '2017-07-01',
        notes: 'This is a new praise set'
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
