require "test_helper"

class ChordSheetTest < ActiveSupport::TestCase
  # public api
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

  # private methods

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


  test "formatting basic chords as nashville roman numerals works correctly" do
    assert_equal "I", chord_sheet("G").send(:format_chord_nashville, "G")
    assert_equal "ii", chord_sheet("G").send(:format_chord_nashville, "Am")
    assert_equal "iii", chord_sheet("G").send(:format_chord_nashville, "Bm")
    assert_equal "IV", chord_sheet("G").send(:format_chord_nashville, "C")
    assert_equal "V", chord_sheet("G").send(:format_chord_nashville, "D")
    assert_equal "vi", chord_sheet("G").send(:format_chord_nashville, "Em")
    assert_equal "vii", chord_sheet("G").send(:format_chord_nashville, "F#dim")

    assert_equal "I", chord_sheet("Bb").send(:format_chord_nashville, "Bb")
    assert_equal "ii", chord_sheet("Bb").send(:format_chord_nashville, "Cm")
    assert_equal "iii", chord_sheet("Bb").send(:format_chord_nashville, "Dm")
    assert_equal "IV", chord_sheet("Bb").send(:format_chord_nashville, "Eb")
    assert_equal "V", chord_sheet("Bb").send(:format_chord_nashville, "F")
    assert_equal "vi", chord_sheet("Bb").send(:format_chord_nashville, "Gm")
    assert_equal "vii", chord_sheet("Bb").send(:format_chord_nashville, "Adim")
  end

  test "formatting accidental chords as nashville roman numerals works correctly" do
    assert_equal "iiib", chord_sheet("G").send(:format_chord_nashville, "Bbm")
    assert_equal "IV#", chord_sheet("G").send(:format_chord_nashville, "C#")
  end

  test "formatting doesn't affect chord modifiers execept for minor and diminished" do
    assert_equal "Vmaj7", chord_sheet("G").send(:format_chord_nashville, "Dmaj7")
    assert_equal "Isus", chord_sheet("G").send(:format_chord_nashville, "Gsus")
    assert_equal "Is", chord_sheet("G").send(:format_chord_nashville, "Gs")
    assert_equal "iii4", chord_sheet("G").send(:format_chord_nashville, "Bm4")
    assert_equal "V(b5)", chord_sheet("G").send(:format_chord_nashville, "D(b5)")
  end

  def chord_sheet(key)
    ChordSheet.new("garbage", key)
  end

end