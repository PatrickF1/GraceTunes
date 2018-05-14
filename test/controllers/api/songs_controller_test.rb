require 'test_helper'
require_relative 'api_controller_test.rb'

class API::SongsControllerTest < API::APIControllerTest

  test 'recently_updated should retrieve only songs updated after date specified' do
    get :recently_updated
    assert_response :success
  end

  test 'recently_updated should retrieve all songs if no date specified' do
  end

  test 'recently_updated should not be accessible without correct HTTP auth headers' do
  end
end