require "test_helper"

class SongTest < ActiveSupport::TestCase

  test "should not save without name" do
    song = songs(:God_be_praised)
    song.name = nil
    assert_not song.save, "Saved without a name"
  end

  test "should not save without a valid key" do
    song = songs(:God_be_praised)
    song.key = "ab"
    assert_not song.save, "Saved with an invalid key"
    song.key = nil
    assert_not song.save, "Saved without a key"
  end

  test "should not save without a valid tempo" do
    song = songs(:God_be_praised)
    song.tempo = "really fast"
    assert_not song.save, "Saved with an invalid tempo"
    song.tempo = nil
    assert_not song.save, "Saved without a tempo"
  end

  test "should not save without a chord sheet" do
    song = songs(:God_be_praised)
    song.chord_sheet = nil
    assert_not song.save, "Saved without a chord sheet"
  end

  test "should save without trailing whitespaces in the chord sheet" do
    song = songs(:God_be_praised)
    song.chord_sheet = " a b c             "
    song.save
    # leaving leading whitespaces untouched on purpose
    assert_equal(song.chord_sheet, " a b c")
  end

  test "never leaves lyrics field blank" do
    song = songs(:God_be_praised)
    song.lyrics = nil
    song.save
    assert_not_equal(song.lyrics, nil)
  end

  test "normalizes name and artist" do
    song = songs(:God_be_praised)
    song.name = "a name"
    song.artist = "a band"
    song.save
    assert_equal(song.name, "A Name")
    assert_equal(song.artist, "A Band")
  end

  test "extracted lyrics don't contain headers" do
    song = songs(:all_my_hope)
    force_lyrics_extraction(song)
    assert_no_match(/Verse \d:/, song.lyrics, "Lyrics contained verse headers")
    assert_not_includes(song.lyrics, "Chorus:", "Lyrics contained chorus header")
  end

  test "extracted lyrics don't contain chords" do
    song = songs(:all_my_hope)
    force_lyrics_extraction(song)
    assert_no_match Parser::CHORD_REGEX, song.lyrics
  end

  test "extracted lyrics contains all of the lyric lines from chord_sheet" do
    song = songs(:all_my_hope)
    force_lyrics_extraction(song)
    num_lyric_lines = song.lyrics.split("\n").length
    assert_equal(num_lyric_lines, 18)
  end

  # full text search tests
  single_word_results = Song.search_by_keywords "relevant"
  multi_word_results = Song.search_by_keywords "truth live life hands"
  partial_word_results = Song.search_by_keywords "hand"

  test "search should prioritize songs with the keyword in the title" do
    assert_equal(single_word_results.first, songs(:relevant_1))
  end

  test "search should prioritize songs with more occurances of the keyword" do
    assert_equal(single_word_results.second, songs(:relevant_2))
    assert_equal(single_word_results.third, songs(:relevant_3))
  end

  test "search should not include songs without any occurances of the keyword" do
    assert_not_includes(single_word_results, songs(:relevant_4), "Song without keyword appeared in search")
  end

  test "search should include all songs where at least one keyword present" do
    assert_includes(multi_word_results, songs(:God_be_praised))
    assert_includes(multi_word_results, songs(:forever_reign))
    assert_includes(multi_word_results, songs(:hands_to_the_heaven))
  end

  test "empty search should return no results" do
    assert_equal(Song.search_by_keywords(nil), [])
    assert_equal(Song.search_by_keywords(""), [])
  end

  test "search should include partial matches" do
    assert_includes(partial_word_results, songs(:hands_to_the_heaven))
    assert_includes(partial_word_results, songs(:glorious_day))
  end

  test "search should include artist column" do
    songs = Song.search_by_keywords("Kari Jobe")
    assert_includes(songs, songs(:hands_to_the_heaven))
  end

  test "search should include songs that match on different individual columns" do
    songs = Song.search_by_keywords("church reasons")
    assert_includes(songs, songs(:hands_to_the_heaven))
    assert_includes(songs, songs(:ten_thousand_reasons))
  end

  test "search should be case insensitive" do
    songs = Song.search_by_keywords("hillsong")
    assert_includes(songs, songs(:forever_reign))
  end

  private

  # clear the lyrics and save it to trigger the extract_lyrics callback
  def force_lyrics_extraction(song)
    song.lyrics = nil
    song.save
  end
end
