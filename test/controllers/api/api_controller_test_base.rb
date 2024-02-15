# frozen_string_literal: true

require "test_helper"
class API::ControllerTestBase < ActionController::TestCase
  def setup
    # make sure user is signed in to access the app and can read
    load_user_into_session(users(:reader))
  end

  def grant_edit_privileges
    load_user_into_session(users(:praise_member))
  end

  def grant_deleting_privileges
    load_user_into_session(users(:admin))
  end

  def sign_out
    session.delete(:user_email)
  end

  private

  def load_user_into_session(user)
    session[:user_email] = user.email
    session[:name] = user.name
    session[:role] = user.role
  end
end
