require "test_helper"

class TransposerTest < ActiveSupport::TestCase

  test "transposing basic chords works correctly" do
    assert_equal "G", Transposer.send(:transpose_chord, "C", 0, "G")
    assert_equal "C#", Transposer.send(:transpose_chord, "C", 0, "C#")
    assert_equal "F", Transposer.send(:transpose_chord, "C", -2, "G")
    assert_equal "A", Transposer.send(:transpose_chord, "C", 2, "G")
    assert_equal "E#", Transposer.send(:transpose_chord, "G", -1, "F#")
    assert_equal "C", Transposer.send(:transpose_chord, "G", 1, "B")
    assert_equal "Eb", Transposer.send(:transpose_chord, "B", -1, "E")
    assert_equal "A", Transposer.send(:transpose_chord, "F", -1, "Bb")
    assert_equal "Eb", Transposer.send(:transpose_chord, "G", 3, "C")
  end

  test "transposing accidental chords works correctly" do
    assert_equal "G", Transposer.send(:transpose_chord, "C", -1, "G#")
    assert_equal "Gb", Transposer.send(:transpose_chord, "C", 3, "Eb")
    assert_equal "A", Transposer.send(:transpose_chord, "D", -4, "Db")
  end

  test "transposing doesn't affect chord modifiers" do
    assert_equal "Fmaj7", Transposer.send(:transpose_chord, "Eb", -3, "Abmaj7")
    assert_equal "Gsus", Transposer.send(:transpose_chord, "A", -2, "Asus")
    assert_equal "Bs", Transposer.send(:transpose_chord, "G", 4, "Gs")
    assert_equal "Dm4", Transposer.send(:transpose_chord, "G", 3, "Bm4")
    assert_equal "C(b5)", Transposer.send(:transpose_chord, "D", -2, "D(b5)")
    assert_equal "Bb(b5)", Transposer.send(:transpose_chord, "D", -4, "D(b5)")
  end

end