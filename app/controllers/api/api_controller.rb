class Api::APIController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  http_basic_authenticate_with name: ENV["API_USERNAME"], password: ENV["API_PASSWORD"]
end