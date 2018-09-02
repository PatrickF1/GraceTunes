require 'test_helper'

class PraiseSetTest < ActiveSupport::TestCase
  test 'should save with the proper structure' do
    set = praise_sets(:sws_05142017)
    assert set.save, 'Did not save despite the proper structure'
  end

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
    assert_not set.save, 'Saved with a dangling song id'
  end

  test 'should save despite referencing deleted songs' do
    set = praise_sets(:hillsong)
    song = Song.find(set.praise_set_songs[0]["id"])
    song.destroy!
    assert set.save, 'Did not save with a reference to a deleted song'
  end

  test 'should not save if praise_set_songs is nil' do
    set = praise_sets(:hillsong)
    set.praise_set_songs = nil
    assert_not set.save, 'Saved without praise_set_songs'
  end

  test 'should not save if praise_set_songs are missing fields' do
    set = praise_sets(:hillsong)
    set.praise_set_songs[0].delete("id")
    assert_not set.save, 'Saved with a praise set song that was missing the id field'
  end

  test 'should not save if praise_set_songs is an object' do
    set = praise_sets(:hillsong)
    set.praise_set_songs = set.praise_set_songs[0]
    assert_not set.save, 'Saved with praise_set_songs as an object'
  end

  test 'should not save if praise_set_songs contains an invalid key' do
    set = praise_sets(:hillsong)
    set.praise_set_songs[0]["key"] = "ABCD"
    assert_not set.save, 'Saved with a praise set song that had an invalid key'
  end

  test 'retrieve_songs returns referenced Songs' do
    set = praise_sets(:hillsong)
    songs = set.retrieve_songs
    expected_songs = [songs(:forever_reign), songs(:all_my_hope)]
    assert_equal expected_songs, songs, "did not retrieve the expected songs"
  end

  test 'retrieve_songs returns SongDeletionRecords for songs that have already been deleted' do
    set = praise_sets(:hillsong)
    song = Song.find(set.praise_set_songs[0]["id"])
    song.destroy!
    deletion_record = set.retrieve_songs[0]
    assert_instance_of SongDeletionRecord, deletion_record, "should retrieve the SongDeletionRecord of deleted songs"
    assert_equal song.id, deletion_record.id, "the SongDeletionRecord did not have the same id as the deleted song"
    assert_equal song.name, deletion_record.name, "the SongDeletionRecord did not have the same name as the deleted song"
  end

end