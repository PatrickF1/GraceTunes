require 'test_helper'

class PraiseSetTest < ActiveSupport::TestCase

  test 'should not save without event name' do
    set = praise_sets(:hillsong)
    set.event_name = nil
    assert_not set.save, 'Saved without a name'
  end

  test 'should not save without owner' do
    set = praise_sets(:hillsong)
    set.owner = nil
    assert_not set.save, 'Saved without owner'
  end

  test 'should not save if owner does not exist' do
    set = praise_sets(:hillsong)
    set.owner_email = 'doesntexist@gpmail.org'
    assert_not set.save, 'Saved with an invalid owner_email'
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

  test 'should not save if there are dangling song ids in praise_set_songs' do
    set = praise_sets(:hillsong)
    set.praise_set_songs[0]["id"] = -1
    assert_not set.save 'Saved with a dangling song id'
  end

  test 'should not save if praise_set_songs are missing fields' do
    set = praise_sets(:hillsong)
    set.praise_set_songs[0].delete("id")
    assert_not set.save, 'Saved with a invalid praise set song'
  end

  test 'should not save if praise_set_songs is an object' do
    set = praise_sets(:hillsong)
    set.praise_set_songs = set.praise_set_songs[0]
    assert_not set.save, 'Saved with praise_set_songs as an object'
  end

end