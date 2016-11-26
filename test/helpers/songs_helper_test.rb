require "test_helper"

class SongsHelperTest < ActionView::TestCase
  include SongsHelper

  test "split God Be Praised. Should happen 2 lines early since it's too close to the end" do
    @song = songs(:God_be_praised)
    lines = @song.chord_sheet.split("\n")
    assert_equal [lines[0..48], lines[49..lines.length-1]], get_lines_for_columns
  end

  test "split Forever Reign. Should be at the default 50 line mark" do
    @song = songs(:forever_reign)
    lines = @song.chord_sheet.split("\n")
    assert_equal [lines[0..50], lines[51..lines.length-1]], get_lines_for_columns
  end

  test "split When I think about the Lord. Should only be one column since it's shorter than 50 lines" do
    @song = songs(:when_i_think_about_the_lord)
    lines = @song.chord_sheet.split("\n")
    assert_equal [lines[0..lines.length-1],[]], get_lines_for_columns
  end

  test "lyric_line_far_from_blank? should indicate if a line is a lyric line that is far from a blank" do
    song = songs(:God_be_praised)
    lines = song.chord_sheet.split("\n")
    assert lyric_line_far_from_blank?(14, lines)
    assert_not lyric_line_far_from_blank?(12, lines)
    assert_not lyric_line_far_from_blank?(16, lines)
  end

  test "lyric_line_far_from_blank should never return true for non-lyric lines" do
    song = songs(:God_be_praised)
    lines = song.chord_sheet.split("\n")
    assert_not lyric_line_far_from_blank?(27, lines)
    assert_not lyric_line_far_from_blank?(21, lines)
    assert_not lyric_line_far_from_blank?(20, lines)
    assert_not lyric_line_far_from_blank?(19, lines)
  end

  test "lyric_line_far_from_blank? should treat the end of a song like a blank" do
    song = songs(:God_be_praised)
    lines = song.chord_sheet.split("\n")
    assert_not lyric_line_far_from_blank?(lines.length - 3, lines)
    assert lyric_line_far_from_blank?(lines.length - 5, lines)
  end

  test "line_type_in_range? should indicate if a type of line is within a range of a given line number" do
    song = songs(:God_be_praised)
    lines = song.chord_sheet.split("\n")
    assert_not line_type_in_range?(14, "header", 3, lines)
    assert_not line_type_in_range?(14, "header", -3, lines)
    assert line_type_in_range?(14, "header", -4, lines)
    assert line_type_in_range?(14, "blank", 5, lines)
  end

  test "line_type_in_range? should handle beginning of song" do
    song = songs(:God_be_praised)
    lines = song.chord_sheet.split("\n")
    assert_not line_type_in_range?(1, "lyric", -5, lines)
    assert line_type_in_range?(1, "header", -5, lines)
  end

  test "line_type_in_range? should handle end of song" do
    song = songs(:God_be_praised)
    lines = song.chord_sheet.split("\n")
    assert_not line_type_in_range?(lines.length-1, "header", 5, lines)
    assert line_type_in_range?(lines.length-2, "chord", 5, lines)
  end

  test "get_line_range handles reverse ranges" do
    song = songs(:God_be_praised)
    lines = song.chord_sheet.split("\n")
    assert_equal 5..10, get_line_range(10, 5, lines)
  end

  test "get_line_range starts range at 0 if negative" do
    song = songs(:God_be_praised)
    lines = song.chord_sheet.split("\n")
    assert_equal 0..3, get_line_range(3, -2, lines)
  end

  test "get_line_range ends range at end of given lines if too long" do
    song = songs(:God_be_praised)
    lines = song.chord_sheet.split("\n")
    assert_equal 50..52, get_line_range(50, 55, lines)
  end

  test "get_line_range handles negative and too long of range and backwards at same time" do
    song = songs(:God_be_praised)
    lines = song.chord_sheet.split("\n")
    assert_equal 0..52, get_line_range(100, -74, lines)
  end
end