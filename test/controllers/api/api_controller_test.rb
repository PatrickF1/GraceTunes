require 'test_helper'

class API::APIControllerTest < ActionController::TestCase

  # set HTTP headers needed to use API endpoints
  def setup
    request.headers['Accept'] = :json
    request.headers['Authorization'] = ActionController::HttpAuthentication::Basic
      .encode_credentials('patrick', 'fong')
  end

  def clear_auth_headers
    @request.headers['Authorization'] = nil
  end

end
