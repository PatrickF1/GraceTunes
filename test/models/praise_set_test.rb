require 'test_helper'

class PraiseSetTest < ActiveSupport::TestCase

  test 'should not save without name' do
    set = praise_sets(:hillsong)
    set.event_name = nil
    assert_not set.save, 'Saved without a name'
  end

  test 'should not save without owner' do
    set = praise_sets(:hillsong)
    set.owner = nil
    assert_not set.save, 'Saved without owner'
  end

  test 'should not save without date' do
    set = praise_sets(:hillsong)
    set.event_date = nil
    assert_not set.save, 'Saved without date'
  end

  test 'should not save without archived status' do
    set = praise_sets(:hillsong)
    set.archived = nil
    assert_not set.save, 'Saved without archived'
  end

end