require "test_helper"

class ParserTest < ActiveSupport::TestCase

  test "parser does not identify lyric lines as chords" do
    song = songs(:God_be_praised)
    song.lyrics.split("\n").each do |line|
      assert_not Parser.chords?(line), "lyric line was interpretted as chord"
    end
  end

  test "parser identifies only lines consisting of only chords as chord lines" do
    assert Parser.chords?("        G        D")
    assert Parser.chords?("A      Em      C# D B")
    assert Parser.chords?("A      G/C    G")
    assert Parser.chords?(" D#m  Bb    F#     C#/E#   D#m    Bb   C#")
    assert Parser.chords?("A7 D5       C2")
    assert Parser.chords?("Em7   D#2     B9")
    assert Parser.chords?("Cmaj7       Ebmaj3      D#maj5")
    assert Parser.chords?("DM5       C#M7       AbM3")
    assert Parser.chords?("Em7/G#       F/Cmaj7        DM/Cb3")
    assert Parser.chords?("A(5)     B(7)")
    assert Parser.chords?("D(b5)         E(#)")
    assert_not Parser.chords?("A    C#   text")
  end

  test "parser gets list of chords from line" do
    song = songs(:God_be_praised)
    parser = Parser.new(song.chord_sheet)
    assert_equal ["G", "D"], parser.send(:chords, "   G    D")
    assert_equal ["A", "Em", "C#", "D", "B"],  parser.send(:chords, "A      Em      C# D B")
    assert_equal ["A", "G/C", "G"], parser.send(:chords, "A      G/C    G")
    assert_equal ["D#m", "Bb", "F#", "C#/E#", "D#m", "Bb", "C#"], parser.send(:chords, " D#m  Bb    F#     C#/E#   D#m    Bb   C#")
    assert_equal ["Em7", "D#2", "B9"], parser.send(:chords, "Em7   D#2     B9")
    assert_equal ["Cmaj7", "Ebmaj3", "D#maj5"],  parser.send(:chords, "Cmaj7       Ebmaj3      D#maj5")
    assert_equal ["DM5", "C#M7", "AbM3"], parser.send(:chords, "DM5       C#M7       AbM3")
    assert_equal ["Em7/G#", "F/Cmaj7", "DM/Cb3"], parser.send(:chords, "Em7/G#       F/Cmaj7        DM/Cb3")
    assert_equal ["A(5)", "B(7)"], parser.send(:chords, "A(5)     B(7)")
    assert_equal ["D(b5)", "E(#)"], parser.send(:chords, "D(b5)         E(#)")
    assert_equal [], parser.send(:chords, "A    C#   text")
  end

end