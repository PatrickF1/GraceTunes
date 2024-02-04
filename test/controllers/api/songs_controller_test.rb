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
end
