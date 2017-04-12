require "test_helper"

class ChordSheetTest < ActiveSupport::TestCase
  test "nashville formatting" do
    song = songs(:just_a_test)
    expected_formatting = [
      "Verse 1:",
      "     I             V/VII",
      "This is but a simple test",
      "Chorus:",
      "     VI7",
      "Jessussssssssss"
    ].join("\n") << "\n" # needs the trailing new line

    assert_equal song.sheet.as_nashville_format.chord_sheet, expected_formatting
  end


  test "transposing basic chords works correctly" do
    assert_equal "G", chord_sheet("C").send(:transpose_chord, "G", 0)
    assert_equal "C#", chord_sheet("C").send(:transpose_chord, "C#", 0)
    assert_equal "F", chord_sheet("C").send(:transpose_chord, "G", -2)
    assert_equal "A", chord_sheet("C").send(:transpose_chord, "G", 2)
    assert_equal "E#", chord_sheet("G").send(:transpose_chord, "F#", -1)
    assert_equal "C", chord_sheet("G").send(:transpose_chord, "B", 1)
    assert_equal "Eb", chord_sheet("B").send(:transpose_chord, "E", -1)
    assert_equal "A", chord_sheet("F").send(:transpose_chord, "Bb", -1)
    assert_equal "Eb", chord_sheet("G").send(:transpose_chord, "C", 3)
  end

  test "transposing accidental chords works correctly" do
    assert_equal "G", chord_sheet("C").send(:transpose_chord, "G#", -1)
    assert_equal "Gb", chord_sheet("A").send(:transpose_chord, "Eb", 3)
    assert_equal "A", chord_sheet("D").send(:transpose_chord, "Db", -4)
  end

  test "transposing doesn't affect chord modifiers" do
    assert_equal "Fmaj7", chord_sheet("Eb").send(:transpose_chord, "Abmaj7", -3)
    assert_equal "Gsus", chord_sheet("A").send(:transpose_chord, "Asus", -2)
    assert_equal "Bs", chord_sheet("G").send(:transpose_chord, "Gs", 4)
    assert_equal "Dm4", chord_sheet("G").send(:transpose_chord, "Bm4", 3)
    assert_equal "C(b5)", chord_sheet("D").send(:transpose_chord, "D(b5)", -2)
    assert_equal "Bb(b5)", chord_sheet("D").send(:transpose_chord, "D(b5)", -4)
  end

  def chord_sheet(key)
    ChordSheet.new("garbage", key)
  end

end