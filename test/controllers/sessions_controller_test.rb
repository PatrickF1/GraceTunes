# frozen_string_literal: true

require 'test_helper'
require_relative 'application_controller_test'

class SessionsControllerTest < ApplicationControllerTest
  test "the sign-in button should mention using your A2N account" do
    sign_out
    get :new
    assert_select(
      '.sign-in_button',
      /Acts/i,
      "No mention of Acts 2 Network made on the sign in button."
    )
  end

  test "the sign-in page should redirect the user to the songs index if already signed in" do
    setup
    get :new
    assert_redirected_to songs_path
  end

  test "signing in should set authoritative user fields in the session redirect to songs index" do
    name = "A2N Member"
    email = "member@acts2.network"
    sign_back_in(name, email)

    assert_equal(email, session[:user_email], "Email not set correctly in the session")
    assert_includes(Role::VALID_ROLES, session[:role], "A valid role was not set in the session")

    assert_redirected_to songs_path
  end

  test "signing in should pull the user's role from database when it exists" do
    name = "A2N Member"
    email = "admin@acts2.network"
    sign_back_in(name, email)

    assert_equal(Role::ADMIN, session[:role])
  end

  test "signing in correctly sets the user's name in cookie without city extension" do
    name = "Patrick Fong (Berk/Sf)"
    email = "member@acts2.network"
    sign_back_in(name, email)

    assert_equal('Patrick Fong', cookies[:name])
  end

  test "a failed sign-in should redirect the user to the sign in path" do
    get :error
    assert_redirected_to sign_in_path
  end

  test "create should create never-before-seen users as Readers" do
    email = "never-before-seen@acts2.network"

    assert_difference('User.count', 1, "No new user was created") do
      sign_back_in("Never Seen Before", email)
    end
    assert_equal(Role::READER, User.find(email).role, "New users should have a role of Reader")
  end

  test "destroy should redirect to the sign-in page" do
    get :destroy
    assert_redirected_to sign_in_path
  end

  test "destroy should clear the user's session and cookies" do
    get :destroy
    assert_empty(session.to_hash, "Destroy did not clear the user's session")
    assert_empty(cookies.to_hash, "Destroy did not clear the user's cookies")
  end

  private

  def sign_back_in(name, email)
    sign_out
    # manually mock the info that would be sent by Google servers
    request.env['omniauth.auth'] = {
      "info" => {
        "name" => name,
        "email" => email
      }
    }
    get :create, params: { provider: "google_oauth2" }
  end
end
