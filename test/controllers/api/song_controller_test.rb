
require 'test_helper'

class API::SongsControllerTest < API::APIControllerTest

  test 'recently_updated should retreive only songs updated after date specified' do
    get :recently_updated
  end

  test 'recently_updated should retrieve all songs if no date specified' do
  end

  test 'recently_updated should not be accessible without correct HTTP auth headers' do
  end
end