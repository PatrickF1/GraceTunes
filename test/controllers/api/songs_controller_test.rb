require_relative 'api_controller_test_base'
class API::SongsControllerTest < API::ControllerTestBase

  test "index should require user to be signed in" do
    sign_out
    get :index
    assert_response :forbidden
  end

  test "index should respect page_size param" do
    get :index, params: {page_size: 3}
    assert_response :ok
    @response.parsed_body["data"].size == 3
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
end
