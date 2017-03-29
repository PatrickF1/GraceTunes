require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase

  def setup
    # make sure user is signed in to access the app and can read
    session[:user_email] = users(:reader).email
  end

  def login_as_praise
    session[:user_email] = users(:praise_member).email
  end

  def logout
    session.delete(:user_email)
  end

end
