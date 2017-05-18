require 'test_helper'

class PraiseSetTest < ActiveSupport::TestCase

  test "should not save without name" do
    set = praise_sets(:hillsong)
    set.name = nil
    assert_not set.save, "Saved without a name"
  end

  test "should not save without owner" do
    set = praise_sets(:hillsong)
    set.owner = nil
    assert_not set.save, "Saved without owner"
  end

  test "should save without date" do
    set = praise_sets(:hillsong)
    set.date = nil
    assert set.save!, "Did not save without date"
  end
end
