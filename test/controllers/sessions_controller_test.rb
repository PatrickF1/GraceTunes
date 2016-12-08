require 'test_helper'
require_relative 'application_controller_test.rb'

class SessionsControllerTest < ApplicationControllerTest
  
  test "the sign-in page should mention using your Gpmail account" do
    logout
    get :new
    assert_select '.sign-in-page', /Gpmail/
  end

  test "the sign-in page should redirect the user to the root path if already signed in" do
    get :new
    assert_redirected_to root_path
  end

  test "signing out redirects to the sign-in page" do
    get :destroy
    assert_redirected_to sign_in_path
  end

  test "signing in should set user_email in the session and redirect to root" do
    logout
    email = "gpmember@gpmail.org"
    # manually mock the info that would be sent by Google servers
    request.env['omniauth.auth'] = {
      "info" => {
          "name" => "Gracepoint Member",
          "email" => email
      }
    }
    get :create, provider: "google_oauth2"
    assert_equal(email, session[:user_email] , "Email not set correctly in the session")
    assert_redirected_to root_path
  end

  test "a failed sign-in should redirect the user to the sign in path" do
    get :error
    assert_redirected_to sign_in_path
  end
end
