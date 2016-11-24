module SongsHelper
  MAX_LINES = 50
  LINE_PADDING = 4
  private_constant :MAX_LINES

  def get_class_for_line(line)
    if line == ""
      "blank"
    elsif Parser.header? line
      "header"
    elsif Parser.chords? line
      "chord"
    else
      "lyric"
    end
  end

  def get_lines_for_columns
    byebug
    lines = @song.chord_sheet.split("\n")
    # find a good place to split the two columns
    midpoint = [MAX_LINES, lines.length-1].min
    until "blank" == get_class_for_line(lines[midpoint]) || lyric_line_far_from_blank?(midpoint, lines) do
      midpoint -= 1
    end
    return lines[0 .. midpoint], lines[midpoint + 1 .. -1]
  end

  def lyric_line_far_from_blank?(line_num, lines)
    return false if "lyric" != get_class_for_line(lines[line_num])
    # if both the end, and a blank line is more than 5 lines away in either direction, this line is good to break on
    line_num < lines.length - LINE_PADDING &&
      !(line_type_in_range?(line_num, "blank", LINE_PADDING, lines) || line_type_in_range?(line_num, "blank", -LINE_PADDING, lines))
  end

  def line_type_in_range?(line_num, line_type, range, lines)
    end_range = limit_by_range(0, line_num + range, lines.length - 1)
    (line_num..end_range).each do |num|
      if(line_type == get_class_for_line(lines[num]))
        return true
      end
    end
    false
  end

  def limit_by_range(min, value, max)
    return min if value < min
    return max if value > max
    value
  end

end
