require 'test_helper'

class API::APIControllerTest < ActionController::TestCase

  # set basic HTTP authentication headers
  def setup
    @request.headers['Authorization'] = ActionController::HttpAuthentication::Basic
      .encode_credentials(ENV['API_USERNAME'], ENV['API_PASSWORD'])
  end

  def clear_auth_headers
    @request.headers['Authorization'] = nil
  end

end
