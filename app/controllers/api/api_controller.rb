class API::APIController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods
end
