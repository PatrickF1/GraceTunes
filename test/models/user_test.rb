require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "users with no email should be considered guests" do
    user = User.new(nil, "Name")
    assert user.guest?
    assert_not user.signed_in?
  end

  test "users with an email should be logged in" do
    user = User.new("someEmail@example.com", "Name")
    assert user.signed_in?
    assert_not user.guest?
  end
end