require 'test_helper'

class API::APIControllerTest < ActionController::TestCase

  # set up the HTTP headers needed to use API endpoints
  def setup
    request.headers['Accept'] = 'application/json'
    request.headers['Authorization'] = ActionController::HttpAuthentication::Basic
      .encode_credentials(ENV['API_USERNAME'], ENV['API_PASSWORD'])
  end

  def clear_auth_headers
    request.headers['Authorization'] = nil
  end

end
