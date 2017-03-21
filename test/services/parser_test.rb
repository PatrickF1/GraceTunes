require "test_helper"

class ParserTest < ActiveSupport::TestCase

  def parser_setup
    song = songs(:God_be_praised)
    @parser = Parser.new(song.chord_sheet)
  end

  test "chord regex should return false for lyric lines" do
    song = songs(:God_be_praised)
    song.lyrics.split("\n").each do |line|
      assert_not Parser.chords?(line), "lyric line was interpretted as chord"
    end
  end

  test "chord regext should return true for line fully composed of chords" do
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

end