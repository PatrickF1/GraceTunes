module SongsHelper
  MAX_LINES = 50
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
    lines = @song.chord_sheet.split("\n")
    # find a good place to split the two columns
    midpoint = [MAX_LINES, lines.length-1].min
    until "blank" == get_class_for_line(lines[midpoint]) || lyric_line_far_from_blank(midpoint, lines) do
      midpoint -= 1
    end
    return lines[0 .. midpoint], lines[midpoint + 1 .. -1]
  end

  private

  def lyric_line_far_from_blank(line_num, lines)
    return false if "lyric" != get_class_for_line(lines[line_num])
    # if a blank line is less than 5 lines away, this line is too close to a blank
    true unless line_type_in_range(line_num, "blank", 4, lines) || line_type_in_range(line_num, "blank", -4, lines)
  end

  def line_type_in_range(line_num, line_type, range, lines)
    (line_num..line_num + range).each do |num|
      if(line_type == get_class_for_line(lines[num]))
        return true
      end
    end
    false
  end

end
