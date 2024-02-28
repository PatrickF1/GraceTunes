# frozen_string_literal: true

require "test_helper"

class FormatterTest < ActiveSupport::TestCase
  test "formatting basic chords as nashville roman numerals works correctly" do
    assert_equal "I", Formatter.send(:format_chord_nashville, "G", "G")
    assert_equal "ii", Formatter.send(:format_chord_nashville, "Am", "G")
    assert_equal "iii", Formatter.send(:format_chord_nashville, "Bm", "G")
    assert_equal "IV", Formatter.send(:format_chord_nashville, "C", "G")
    assert_equal "V", Formatter.send(:format_chord_nashville, "D", "G")
    assert_equal "vi", Formatter.send(:format_chord_nashville, "Em", "G")
    assert_equal "vii", Formatter.send(:format_chord_nashville, "F#dim", "G")

    assert_equal "I", Formatter.send(:format_chord_nashville, "Bb", "Bb")
    assert_equal "ii", Formatter.send(:format_chord_nashville, "Cm", "Bb")
    assert_equal "iii", Formatter.send(:format_chord_nashville, "Dm", "Bb")
    assert_equal "IV", Formatter.send(:format_chord_nashville, "Eb", "Bb")
    assert_equal "V", Formatter.send(:format_chord_nashville, "F", "Bb")
    assert_equal "vi", Formatter.send(:format_chord_nashville, "Gm", "Bb")
    assert_equal "vii", Formatter.send(:format_chord_nashville, "Adim", "Bb")
  end

  test "formatting accidental chords as nashville roman numerals works correctly" do
    assert_equal "iiib", Formatter.send(:format_chord_nashville, "Bbm", "G")
    assert_equal "IV#", Formatter.send(:format_chord_nashville, "C#", "G")
  end

  test "formatting doesn't affect chord modifiers execept for minor and diminished" do
    assert_equal "Vmaj7", Formatter.send(:format_chord_nashville, "Dmaj7", "G")
    assert_equal "Isus", Formatter.send(:format_chord_nashville, "Gsus", "G")
    assert_equal "Is", Formatter.send(:format_chord_nashville, "Gs", "G")
    assert_equal "iii4", Formatter.send(:format_chord_nashville, "Bm4", "G")
    assert_equal "V(b5)", Formatter.send(:format_chord_nashville, "D(b5)", "G")
  end
end
