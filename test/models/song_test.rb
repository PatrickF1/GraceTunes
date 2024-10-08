# frozen_string_literal: true

require "test_helper"

class SongTest < ActiveSupport::TestCase
  test "should be invalid without a name" do
    song = songs(:God_be_praised)
    song.name = nil
    assert_not song.valid?
  end

  test "should be valid without an artist" do
    song = songs(:God_be_praised)
    song.artist = nil
    assert song.valid?
  end

  test "should be invalid without a valid key" do
    song = songs(:God_be_praised)
    song.key = "ab"
    assert_not song.valid?
    song.key = nil
    assert_not song.valid?
  end

  test "should be invalid without a valid tempo" do
    song = songs(:God_be_praised)
    song.tempo = "really fast"
    assert_not song.valid?
    song.tempo = nil
    assert_not song.valid?, "Was valid without a tempo"
  end

  test "should be invalid with an impossible BPM" do
    song = songs(:ten_thousand_reasons)
    song.bpm = 0
    assert_not song.valid?, "Was valid with a BPM of 0"
    song.bpm = 9000
    assert_not song.valid?, "Was valid with a BPM of 9000"
  end

  test "should be invalid when category is invalid" do
    song = songs(:ten_thousand_reasons)
    song.category = "nothing"
    assert_not song.valid?, "Was valid with a an invalid category"
  end

  test "should be invalid with a Spotify URI containing spaces" do
    song = songs(:ten_thousand_reasons)
    song.spotify_uri = "obviously invalid Spotify URI"
    assert_not song.valid?
  end

  test "should upcase the standard scan" do
    song = songs(:God_be_praised)
    lowercased_standard_scan = "t. v1. v2. pc. c."
    song.standard_scan = lowercased_standard_scan
    assert song.valid?
    assert_equal(
      song.standard_scan,
      lowercased_standard_scan.upcase,
      "The standard scan was not upcased during validation"
    )
  end

  test "should be valid with only one space between section abbreviations" do
    song = songs(:God_be_praised)
    spaced_out_standard_scan = "V1.          V2.        V3.        "
    song.standard_scan = spaced_out_standard_scan
    assert song.valid?
    assert_nil(
      song.standard_scan.index("  "),
      "Extra spaces in the standard scan were not removed during validation"
    )
  end

  test "should add a period to standard scan abbreviations if there isn't already one" do
    song = songs(:God_be_praised)
    song.standard_scan = "V1 V2 V3"
    song.valid?
    assert_equal(song.standard_scan,
                 "V1. V2. V3.",
                 "The abbreviations in the standard scan are not trailed by a period")
  end

  test "should be invalid without a chord sheet" do
    song = songs(:God_be_praised)
    song.chord_sheet = nil
    assert_not song.valid?
  end

  test "should be invalid with line that is too long" do
    song = songs(:God_be_praised)
    song.chord_sheet += "This is a really long line. It is more than 45 characters so it's too long"
    assert_not song.valid?, "Was valid despite too long of a line in chord sheet"
  end

  test "should remove trailing whitespaces in the chord sheet during validation" do
    song = songs(:God_be_praised)
    song.chord_sheet = "     E                            G#m                 "
    assert song.valid?
    # leaving leading whitespaces untouched on purpose
    assert_equal(song.chord_sheet, "     E                            G#m")
  end

  test "should uppercase header lines" do
    song = songs(:glorious_day)
    song.chord_sheet = "this is a header:"
    assert song.valid?
    assert_equal(song.chord_sheet, "THIS IS A HEADER:", "Header not uppercased")
  end

  test "should never leave lyrics field blank when saving" do
    song = songs(:God_be_praised)
    song.lyrics = nil
    assert song.save
    assert_not_equal(song.lyrics, nil)
  end

  test "normalizes name and artist during validations" do
    song = songs(:God_be_praised)
    song.name = "a name"
    song.artist = "a band"
    song.valid?
    assert_equal(song.name, "A Name")
    assert_equal(song.artist, "A Band")
  end

  test "extracted lyrics don't contain headers" do
    song = songs(:all_my_hope)
    force_lyrics_extraction(song)
    assert_no_match(/Verse \d:/, song.lyrics, "Lyrics contained verse headers")
    assert_not_includes(song.lyrics, "CHORUS:", "Lyrics contained chorus header")
  end

  test "extracted lyrics don't contain chords" do
    song = songs(:all_my_hope)
    force_lyrics_extraction(song)
    assert_no_match Parser::CHORD_LINE_REGEX, song.lyrics
  end

  test "extracted lyrics contains all of the lyric lines from chord_sheet" do
    song = songs(:all_my_hope)
    force_lyrics_extraction(song)
    num_lyric_lines = song.lyrics.split("\n").length
    assert_equal(num_lyric_lines, 18)
  end

  test "should be invalid if it shares the same name and artist as an existing song" do
    existing_song = songs(:glorious_day)
    new_song = Song.new(
      name: existing_song.name,
      artist: existing_song.artist,
      tempo: Song::VALID_TEMPOS.first,
      key: Song::VALID_KEYS.first,
      chord_sheet: "testing"
    )
    assert_not new_song.valid?, "Was valid despite another song with the same name and artist"
  end

  test "should be valid even if another song shares the same name but not artist" do
    existing_song = songs(:glorious_day)
    new_song = existing_song.dup
    new_song.artist = "#{new_song.artist} different"
    assert new_song.valid?
  end

  # auditing tests
  test "should audit updates" do
    execute_with_auditing do
      song = songs(:all_my_hope)
      song.name = "Updated Name"
      assert song.save
      assert_not_empty song.audits, "Updating a song was not audited"
    end
  end

  test "should audit model creation" do
    execute_with_auditing do
      new_song = songs(:all_my_hope).dup
      new_song.name = "Song about to be created"
      assert new_song.save
      assert_not_empty new_song.audits, "Creating a song was not audited"
    end
  end

  test "should not audit changes to song lyrics" do
    # lyrics should not be audited because they are auto-generated from
    # the chord sheet and should never be changed directly by users
    execute_with_auditing do
      song = songs(:all_my_hope).dup
      song.name = "Song about to be created"
      assert song.save
      assert_nil(
        song.audits[0].audited_changes["lyrics"],
        "Lyrics were audited when creating a song"
      )

      song.chord_sheet = "lyrics have changed"
      assert song.save
      assert_nil(
        song.audits[0].audited_changes["lyrics"],
        "Lyrics were audited when updating a song's chord sheet"
      )
    end
  end

  # full text search tests
  single_word_results = Song.search_by_keywords "praise"
  multi_word_results = Song.search_by_keywords "Holy Lord"

  test "search should prioritize songs with the keyword in the title" do
    assert_equal(songs(:God_be_praised), single_word_results.first)
  end

  test "search should prioritize songs with more occurrences of the keyword" do
    # when_i_think_about_the_lord has three occurrences of "praise"
    # ten_thousand_reasons and glorious_day both have only one occurence
    assert_equal(songs(:when_i_think_about_the_lord), single_word_results.second)
    assert_includes(single_word_results[2..3], songs(:ten_thousand_reasons))
    assert_includes(single_word_results[2..3], songs(:glorious_day))
  end

  test "search should not include songs without occurrences of all keywords" do
    # these songs only contain the word "Lord"
    [songs(:forever_reign), songs(:God_be_praised), songs(:glorious_day)].each do |song|
      assert_not_includes(
        multi_word_results,
        song,
        "Song without both keywords appeared in search"
      )
    end
  end

  test "search should include all songs where all the keywords are present" do
    assert_includes(multi_word_results, songs(:ten_thousand_reasons))
    assert_includes(multi_word_results, songs(:when_i_think_about_the_lord))
  end

  test "empty search should return no results" do
    assert_equal(Song.search_by_keywords(nil), [])
    assert_equal(Song.search_by_keywords(""), [])
  end

  test "search should include partial matches" do
    results = Song.search_by_keywords "hand"
    assert_includes(results, songs(:hands_to_the_heaven))
    assert_includes(results, songs(:glorious_day))
  end

  test "search should include artist column" do
    songs = Song.search_by_keywords("Kari Jobe")
    assert_includes(songs, songs(:hands_to_the_heaven))
  end

  test "search should include songs that match on different individual columns" do
    songs = Song.search_by_keywords("praised forever")
    assert_includes(songs, songs(:God_be_praised))
  end

  test "search should be case insensitive" do
    songs = Song.search_by_keywords("hillsong")
    assert_includes(songs, songs(:forever_reign))
  end

  private

  # clear the lyrics and validate it to trigger the extract_lyrics callback
  def force_lyrics_extraction(song)
    song.lyrics = nil
    assert song.save, "Was expecting the song to save in order to extract the lyrics"
  end

  # temporarily enable Song auditing
  def execute_with_auditing
    Song.auditing_enabled = true
    yield
  ensure
    Song.auditing_enabled = false
  end
end
