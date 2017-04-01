require "test_helper"

class ParserTest < ActiveSupport::TestCase

  test "parser does not identify lyric lines as chords" do
    song = songs(:God_be_praised)
    song.lyrics.split("\n").each do |line|
      assert_not Parser.chords_line?(line), "lyric line was interpretted as chord"
    end
  end

  test "parser identifies only lines consisting of only chords as chord lines" do
    assert Parser.chords_line?("        G        D")
    assert Parser.chords_line?("A      Em      C# D B")
    assert Parser.chords_line?("A      G/C    G")
    assert Parser.chords_line?(" D#m  Bb    F#     C#/E#   D#m    Bb   C#")
    assert Parser.chords_line?("A7 D5       C2")
    assert Parser.chords_line?("Em7   D#2     B9")
    assert Parser.chords_line?("Cmaj7       Ebmaj3      D#maj5")
    assert Parser.chords_line?("DM5       C#M7       AbM3")
    assert Parser.chords_line?("Em7/G#       F/Cmaj7        DM/Cb3")
    assert Parser.chords_line?("A(5)     B(7)")
    assert Parser.chords_line?("D(b5)         E(#)")
    assert_not Parser.chords_line?("A    C#   text")
  end

  test "parser gets list of chords from line" do
    assert_equal ["G", "D"], Parser.chords_from_line("   G    D")
    assert_equal ["A", "Em", "C#", "D", "B"],  Parser.chords_from_line("A      Em      C# D B")
    assert_equal ["A", "G", "C", "G"], Parser.chords_from_line("A      G/C    G")
    assert_equal ["D#m", "Bb", "F#", "C#", "E#", "D#m", "Bb", "C#"], Parser.chords_from_line(" D#m  Bb    F#     C#/E#   D#m    Bb   C#")
    assert_equal ["Em7", "D#2", "B9"], Parser.chords_from_line("Em7   D#2     B9")
    assert_equal ["Cmaj7", "Ebmaj3", "D#maj5"],  Parser.chords_from_line("Cmaj7       Ebmaj3      D#maj5")
    assert_equal ["Em7", "G#", "F", "Cmaj7", "D", "Cb3"], Parser.chords_from_line("Em7/G#       F/Cmaj7        D/Cb3")
    assert_equal ["A(5)", "B(7)"], Parser.chords_from_line("A(5)     B(7)")
    assert_equal ["D(b5)", "E(#)"], Parser.chords_from_line("D(b5)         E(#)")
    assert_equal [], Parser.chords_from_line("A    C#   text")
  end

end