module SongsHelper
  MAX_LINES_PER_COL = 50
  LINE_PADDING = 4
  private_constant :MAX_LINES_PER_COL
  private_constant :LINE_PADDING

  def get_tempo_opts(selected, include_any = false)
    options = Song::VALID_TEMPOS.map { |t| [t, t] }
    options.insert(0, ['Any', '']) if include_any
    options_for_select(options, selected: selected)
  end

  def get_key_opts(selected, include_any = false)
    options = Song::VALID_KEYS.map { |k| [k, k] }
    options.insert(0, ['Any', '']) if include_any
    options_for_select(options, selected: selected)
  end

  def get_class_for_line(line)
    if line == ""
      "blank"
    elsif Parser.header_line? line
      "header"
    elsif Parser.chords_line? line
      "chord"
    else
      "lyric"
    end
  end

  def get_lines_for_columns
    lines = @sheet.chord_sheet.split("\n")
    return lines, [] if lines.length <= MAX_LINES_PER_COL

    # find a good place to split the two columns
    midpoint = MAX_LINES_PER_COL
    until "blank" == get_class_for_line(lines[midpoint]) || lyric_line_far_from_blank?(midpoint, lines) do
      midpoint -= 1
    end
    return lines[0 .. midpoint], lines[midpoint + 1 .. -1]
  end

  private

  def lyric_line_far_from_blank?(line_num, lines)
    return false if "lyric" != get_class_for_line(lines[line_num])
    # if this line is not too close to the end, and there is no blank too close, this lyric line is far enough
    line_num < lines.length - LINE_PADDING &&
      !(line_type_in_range?(line_num, "blank", LINE_PADDING, lines) || line_type_in_range?(line_num, "blank", -LINE_PADDING, lines))
  end

  def line_type_in_range?(line_num, line_type, range, lines)
    get_line_range(line_num, line_num + range, lines).each do |num|
      if(line_type == get_class_for_line(lines[num]))
        return true
      end
    end
    false
  end

  def get_line_range(start, ending, lines)
    if(ending < start)
      return ([0, ending].max)..([start, lines.length-1].min)
    else
      return ([0, start].max)..([ending, lines.length-1].min)
    end
  end

end
