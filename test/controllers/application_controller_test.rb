require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase
  
  def setup
    # make sure user is signed in to access the app
    session[:user_email] = "example@example.com"
    session[:user_name] = "Name"
  end

  def logout
    session.delete(:user_email)
    session.delete(:user_name)
  end

end
