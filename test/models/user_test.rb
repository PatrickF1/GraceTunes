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

  test "should not be able to save a user with an existing email" do
    duplicate_user = User.new(
      email: users(:praise_member).email,
      name: "Duplicate User",
      role: "Reader"
    )
    assert_not duplicate_user.save, "saved a user with an existing email"
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

  test "should not save without a role" do
    user_nil_role = User.new(
      email: "test@email.com",
      name: "Name"
    )
    assert_not user_nil_role.save, "saved with a nil role"

    user_blank_role = User.new(
      email: "test@email.com",
      name: "Name",
      role: ""
    )
    assert_not user_blank_role.save, "saved with a blank role"
  end

  test "email and name should be normalized" do
    user = User.new(
      email: "manySpaces@end.com    ",
      name: "lowercase name   ",
      role: Role::READER
    )
    assert user.save
    assert_equal(user.email, "manySpaces@end.com")
    assert_equal(user.name, "Lowercase Name")
  end

  test "readers should not be able to perform write actions" do
    reader = users(:reader)
    assert_not reader.can_edit?, "readers can edit"
    assert_not reader.can_delete?, "readers can delete"
  end

  test "praise members should not be able to delete" do
    praise_member = users(:praise_member)
    assert_not praise_member.can_delete?, "praise members can delete"
  end

  test "praise members should be able to edit" do
    praise_member = users(:praise_member)
    assert praise_member.can_edit?, "praise members can't edit"
  end

  test "admins can do perform any action" do
    admin = users(:admin)
    assert admin.can_edit?, "admins can't edit"
    assert admin.can_delete?, "admins can't delete"
  end
end