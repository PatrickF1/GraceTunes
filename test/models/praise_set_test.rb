require 'test_helper'

class PraiseSetTest < ActiveSupport::TestCase

  test "should not save without name" do
    set = praise_sets(:hillsong)
    set.event_name = nil
    assert_not set.save, "Saved without a name"
  end

  test "should not save without owner" do
    set = praise_sets(:hillsong)
    set.owner = nil
    assert_not set.save, "Saved without owner"
  end

  test "should not save without date" do
    set = praise_sets(:hillsong)
    set.event_date = nil
    assert_not set.save, "Saved without date"
  end

  test "should not save without archived status" do
    set = praise_sets(:hillsong)
    set.archived = nil
    assert_not set.save, "Saved without archived"
  end

  test "add_song should add song to praise_set songs list" do
    praise_set = praise_sets(:sws_05142017)
    new_song = songs(:all_my_hope)
    assert_difference 'praise_set.songs.size', 1 do
      praise_set.add_song(new_song)
    end
  end

  test "add_song should add song to end of praise_set songs list" do
    praise_set = praise_sets(:sws_05142017)
    new_song = songs(:all_my_hope)
    praise_set.add_song(new_song)
    assert_equal praise_set.songs.last, new_song, "New song isn't added to end of songs list"
  end

end
