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

  test 'songs should get all song models from the json in the same order' do
    praise_set = praise_sets(:relevant_songs)
    expected_songs = [ songs(:relevant_1), songs(:relevant_2), songs(:relevant_3), songs(:relevant_4)]
    assert_equal expected_songs, praise_set.songs
  end

  test 'songs should get all song models with the correct key from the json' do
    praise_set = praise_sets(:relevant_songs)
    song1 = songs(:relevant_1)
    song2 = songs(:relevant_2)
    song3 = songs(:relevant_3)
    song4 = songs(:relevant_4)
    song2.key = "G"
    song3.key = "A"
    expected_songs = [ song1, song2, song3, song4 ]
    assert_equal expected_songs.map { |song| song.key }, praise_set.songs.map { |song| song.key }
  end
end

