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
    assert Parser.chords_line?("    Eb      Gbaug   ")
    assert Parser.chords_line?("  A7sus        Fm7sus       G#msus")
    assert Parser.chords_line?("Em7/G#       F/Cmaj7        D/Cb3")
    assert Parser.chords_line?("A(5)     B(7)")
    assert Parser.chords_line?("D(b5)         E(#)")
    assert Parser.chords_line?("D2       A/C#        E    (A)")
    assert Parser.chords_line?("    E     (D(b5))")
    assert_not Parser.chords_line?("AM     DM") # don't allow 'M' for major since it's confusing
    assert_not Parser.chords_line?("Amin    Dmin") # don't allow 'min' for minor since it's confusing
    assert_not Parser.chords_line?("A    C#   text")
  end

  test "parser identifies roman numeral lines" do
    assert Parser.chords_line?("    I    ii  iii   IV")
    assert Parser.chords_line?("   V     vi    vii    I")
    assert Parser.chords_line?("   iii2    Vmaj7     Isus")
    assert Parser.chords_line?("    VIb    III#3     ")
    assert Parser.chords_line?("    I(b5)     iii(3)    ")
    assert_not Parser.chords_line?("     I     ii     text")
  end

  test "parser gets list of chords from line" do
    assert_equal ["G", "D"], Parser.chords_from_line("   G    D")
    assert_equal ["A", "Em", "C#", "D", "B"],  Parser.chords_from_line("A      Em      C# D B")
    assert_equal ["A", "G", "C", "G"], Parser.chords_from_line("A      G/C    G")
    assert_equal ["D#m", "Bb", "F#", "C#", "E#", "D#m", "Bb", "C#"], Parser.chords_from_line(" D#m  Bb    F#     C#/E#   D#m    Bb   C#")
    assert_equal ["Em7", "D#2", "B9"], Parser.chords_from_line("Em7   D#2     B9")
    assert_equal ["Cmaj7", "Ebmaj3", "D#maj5"],  Parser.chords_from_line("Cmaj7       Ebmaj3      D#maj5")
    assert_equal ["Em7", "G#", "F", "Cmaj7", "D", "Cb3"], Parser.chords_from_line("Em7/G#       F/Cmaj7        D/Cb3")
    assert_equal ["E7sus4"], Parser.chords_from_line("E7sus4    ")
    assert_equal ["A(5)", "B(7)"], Parser.chords_from_line("A(5)     B(7)")
    assert_equal ["D(b5)", "E(#)"], Parser.chords_from_line("D(b5)         E(#)")
    assert_equal ["Eb", "(A)"], Parser.chords_from_line("   Eb     (A)")
    assert_equal [], Parser.chords_from_line("A    C#   text")
  end

  test "parsing chord into hash with categorized information" do
    parsed_g = { base: "G", chord: "G", modifiers: [] }
    assert_equal parsed_g, Parser.parse_chord("G")
    parsed_am = { base: "A", chord: "Am", modifiers: [:minor] }
    assert_equal parsed_am, Parser.parse_chord("Am")
    parsed_Bbm = { base: "Bb", chord: "Bbm", modifiers: [:minor] }
    assert_equal parsed_Bbm, Parser.parse_chord("Bbm")
    parsed_D7 = { base: "D", chord: "D7", modifiers: [:number] }
    assert_equal parsed_D7, Parser.parse_chord("D7")
    parsed_Fmaj7 = { base: "F", chord: "Fmaj7", modifiers: [:major_seventh, :number] }
    assert_equal parsed_Fmaj7, Parser.parse_chord("Fmaj7")
    parsed_Ebm2 = { base: "Eb", chord: "Ebm2", modifiers: [:minor, :number] }
    assert_equal parsed_Ebm2, Parser.parse_chord("Ebm2")
    parsed_Gsus4 = { base: "G", chord: "Gsus4", modifiers: [:suspended, :number] }
    assert_equal parsed_Gsus4, Parser.parse_chord("Gsus4")
    parsed_FsharpDim7 = { base: "F#", chord: "F#dim7", modifiers: [:diminished, :number] }
    assert_equal parsed_FsharpDim7, Parser.parse_chord("F#dim7")
    parsed_Gs = { base: "G", chord: "Gs", modifiers: [:suspended] }
    assert_equal parsed_Gs, Parser.parse_chord("Gs")
    parsed_Gsus = { base: "G", chord: "Gsus", modifiers: [:suspended] }
    assert_equal parsed_Gsus, Parser.parse_chord("Gsus")
    parsed_Daug7 = { base: "D", chord: "Daug7", modifiers: [:augmented, :number] }
    assert_equal parsed_Daug7, Parser.parse_chord("Daug7")
  end

end
