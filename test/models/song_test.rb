require 'test_helper'

class SongTest < ActiveSupport::TestCase
  test "should not save without name" do
    song = songs(:God_be_praised)
    song.name = nil
    assert_not song.save, "Saved without a name"
  end

  test "should not save with invalid keys" do
    song = songs(:God_be_praised)
    song.key = "ab"
    assert_not song.save, "Saved with an invalid key"
  end

  test "should not save with invalid tempo" do
    song = songs(:God_be_praised)
    song.tempo = "really fast"
    assert_not song.save, "Saved with an invalid tempo"
  end

  test "should not save without a song sheet" do
    song = songs(:God_be_praised)
    song.song_sheet = nil
    assert_not song.save, "Saved without a song sheet"
  end

  test "normalizes name and artist" do
    song = songs(:God_be_praised)
    song.name = "a name"
    song.artist = "a band"
    song.save
    assert_equal(song.name, "A Name")
    assert_equal(song.artist, "A Band")
  end
  
  test "search returns correct records" do
    results = Song.search('God')
    correct_results = songs(:God_be_praised)
    assert_equal results.first, correct_results
    assert results.one?
  end
  
  test "search returns no records if no results" do
    results = Song.search('banana')
    assert results.none?
  end
end
