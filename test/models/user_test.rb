require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should not save without an email" do
    user_nil_email = User.new(
      name: "Name",
      role: Role::READER
    )
    assert_not user_nil_email.save, "saved with a nil email"

    user_blank_email = User.new(
      email: "",
      name: "Name",
      role: Role::READER
    )
    assert_not user_blank_email.save, "saved with a blank email"
  end

  test "should not save without a name" do
    user_nil_name = User.new(
      email: "test@email.com",
      role: Role::READER
    )
    assert_not user_nil_name.save, "saved with a nil name"

    user_blank_name = User.new(
      email: "test@email.com",
      name: "",
      role: Role::READER
    )
    assert_not user_blank_name.save, "saved with a blank name"
  end
end