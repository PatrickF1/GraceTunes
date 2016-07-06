require 'test_helper'

class TagTest < ActiveSupport::TestCase
  test "should not save without name" do
    tag = Tag.new
    assert_not tag.save, "Saved without a name"
  end
end
