require 'test_helper'

class SongTest < ActiveSupport::TestCase
  test "should not save without name" do
    song = Song.new
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

  test "normalizes name and artist" do
    song = Song.new
    song.name = "a name"
    song.artist = "a band"
    song.save
    assert_equal(song.name, "A Name")
    assert_equal(song.artist, "A Band")
  end
end
