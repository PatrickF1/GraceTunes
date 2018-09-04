require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should be invalid without an email" do
    user_nil_email = User.new(
      name: "Name",
      role: Role::READER
    )
    assert_not user_nil_email.valid?, "Was valid with a nil email"

    user_blank_email = User.new(
      email: "",
      name: "Name",
      role: Role::READER
    )
    assert_not user_blank_email.valid?, "Was valid with a blank email"
  end

  test "should not be valid if another user shares the same email" do
    duplicate_user = User.new(
      email: users(:praise_member).email,
      name: "Duplicate User",
      role: "Reader"
    )
    assert_not duplicate_user.valid?
  end

  test "should be invalid without a name" do
    user_nil_name = User.new(
      email: "test@email.com",
      role: Role::READER
    )
    assert_not user_nil_name.valid?, "Was valid with a nil name"

    user_blank_name = User.new(
      email: "test@email.com",
      name: "",
      role: Role::READER
    )
    assert_not user_blank_name.valid?, "Was valid with a blank name"
  end

  test "should be invalid without a role" do
    user_nil_role = User.new(
      email: "test@email.com",
      name: "Name"
    )
    assert_not user_nil_role.valid?, "Was valid with a nil role"

    user_blank_role = User.new(
      email: "test@email.com",
      name: "Name",
      role: ""
    )
    assert_not user_blank_role.valid?, "Was valid with a blank role"
  end

  test "email and name should be normalized" do
    user = User.new(
      email: "manySpaces@end.com    ",
      name: "lowercase name   ",
      role: Role::READER
    )
    assert user.valid?
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