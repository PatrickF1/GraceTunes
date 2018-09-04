require 'test_helper'

class PraiseSetTest < ActiveSupport::TestCase

  test 'should be invalid without event name' do
    set = praise_sets(:hillsong)
    set.event_name = nil
    assert_not set.valid?, 'Validated without a name'
  end

  test 'should be invalid without owner' do
    set = praise_sets(:hillsong)
    set.owner = nil
    assert_not set.valid?, 'Was valid without owner'
  end

  test 'should be invalid if owner does not exist' do
    set = praise_sets(:hillsong)
    set.owner_email = 'doesntexist@gpmail.org'
    assert_not set.valid?, 'Was valid with an invalid owner_email'
  end

  test 'should be invalid without date' do
    set = praise_sets(:hillsong)
    set.event_date = nil
    assert_not set.valid?, 'Was valid without date'
  end

  test 'should be invalid without archived status' do
    set = praise_sets(:hillsong)
    set.archived = nil
    assert_not set.valid?, 'Was valid without archived'
  end

  test 'should be valid with the proper praise_set_songs structure' do
    set = praise_sets(:hillsong)
    assert set.valid?, 'Was invalid despite having the proper praise_set_songs structure'
  end

  test 'should be invalid if praise_set_songs references songs that do not and have never existed' do
    set = praise_sets(:hillsong)
    set.praise_set_songs[0]["id"] = -1
    assert_not set.valid?
  end

  test 'should be valid despite referencing deleted songs' do
    set = praise_sets(:hillsong)
    song = Song.find(set.praise_set_songs[0]["id"])
    song.destroy!
    assert set.valid?
  end

  test 'should be invalid if praise_set_songs is nil' do
    set = praise_sets(:hillsong)
    set.praise_set_songs = nil
    assert_not set.valid?, 'Was valid without praise_set_songs'
  end

  test 'should be invalid if praise_set_songs is missing fields' do
    set = praise_sets(:hillsong)
    set.praise_set_songs[0].delete("id")
    assert_not set.valid?, 'Was valid with a praise set song that was missing the id field'
  end

  test 'should be invalid if praise_set_songs is an object' do
    set = praise_sets(:hillsong)
    set.praise_set_songs = set.praise_set_songs[0]
    assert_not set.valid?
  end

  test 'should be invalid if praise_set_songs contains an invalid key' do
    set = praise_sets(:hillsong)
    set.praise_set_songs[0]["key"] = "ABCD"
    assert_not set.valid?, 'Was valid with a praise set song that had an invalid key'
  end

  test 'retrieve_songs returns referenced Songs' do
    set = praise_sets(:hillsong)
    songs = set.retrieve_songs
    expected_songs = [songs(:forever_reign), songs(:all_my_hope)]
    assert_equal expected_songs, songs, "did not retrieve the referenced songs"
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

  test 'retrive_songs raises an exception if a referenced song does not and has never existed' do
    set = praise_sets(:hillsong)
    pss = set.praise_set_songs[1]
    pss["id"] = -1
    assert_raises StandardError do
      set.retrieve_songs
    end
  end

end