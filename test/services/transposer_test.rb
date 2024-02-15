# frozen_string_literal: true

require "test_helper"

class TransposerTest < ActiveSupport::TestCase
  test "transposing basic chords works correctly" do
    assert_equal "G", Transposer.send(:transpose_chord, "G", 0, "C")
    assert_equal "C#", Transposer.send(:transpose_chord, "C#", 0, "C")
    assert_equal "F", Transposer.send(:transpose_chord, "G", -2, "C")
    assert_equal "A", Transposer.send(:transpose_chord, "G", 2, "C")
    assert_equal "E#", Transposer.send(:transpose_chord, "F#", -1, "G")
    assert_equal "C", Transposer.send(:transpose_chord, "B", 1, "G")
    assert_equal "Eb", Transposer.send(:transpose_chord, "E", -1, "B")
    assert_equal "A", Transposer.send(:transpose_chord, "Bb", -1, "F")
    assert_equal "Eb", Transposer.send(:transpose_chord, "C", 3, "G")
  end

  test "transposing accidental chords works correctly" do
    assert_equal "G", Transposer.send(:transpose_chord, "G#", -1, "C")
    assert_equal "Gb", Transposer.send(:transpose_chord, "Eb", 3, "C")
    assert_equal "A", Transposer.send(:transpose_chord, "Db", -4, "D")
  end

  test "transposing doesn't affect chord modifiers" do
    assert_equal "Fmaj7", Transposer.send(:transpose_chord, "Abmaj7", -3, "Eb")
    assert_equal "Gsus", Transposer.send(:transpose_chord, "Asus", -2, "A")
    assert_equal "Bs", Transposer.send(:transpose_chord, "Gs", 4, "G")
    assert_equal "Dm4", Transposer.send(:transpose_chord, "Bm4", 3, "G")
    assert_equal "C(b5)", Transposer.send(:transpose_chord, "D(b5)", -2, "D")
    assert_equal "Bb(b5)", Transposer.send(:transpose_chord, "D(b5)", -4, "D")
  end
end
