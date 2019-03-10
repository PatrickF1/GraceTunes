# based off of https://gist.github.com/andrewstucki/106c9704be9233e197350ceabec6a32c
module Parser

  CHORD_LINE_REGEX = /^(?:\s*\(?(?:(?:(?:[A-G]|I{1,3}|IV|V|VI|VII|i{1,3}|iv|v|vi|vii)[#b]?(?:m|maj|dim)?\d?(?:no|add|s|sus|aug)?\d?)|\/|(?:\([b#]?\d?\)))\)?\s*)+$/
  CHORD_TOKENIZER = /(?:\(?(?:[A-G](?:b)?(?:#)?(?:|maj|m|dim)?\d?(?:|s|sus|aug)*[\d]*)\(?(?:b)?(?:#)?[\d]*?\)?\(?(?:b)?(?:#)?[\d]*?\)?)(?=\/|\s|$)/
  BASE_NOTE_REGEX = /[A-G][b#]?/
  MINOR_CHORD_REGEX = /(?<!di)m(?!aj)/
  MAX_LINES_PER_COL = 50
  LINE_PADDING = 4

  def self.chords_line?(line)
    CHORD_LINE_REGEX.match?(line)
  end

  def self.header_line?(line)
    line[-1] == ":"
  end

  def self.lyrics_line?(line)
    !line.strip.empty? && !chords_line?(line) && !header_line?(line)
  end

  def self.chords_from_line(line)
    return [] unless chords_line?(line)
    line.scan CHORD_TOKENIZER
  end

  # returns { base: base note of chord, chord: original chord, modifiers: list of chord modifiers }
  def self.parse_chord(chord)
    modifiers = []
    if chord.include?('dim')
      modifiers << :diminished
    end
    if chord.include?('sus') || chord.include?('s')
      modifiers << :suspended
    end
    if chord.include?('aug')
      modifiers << :augmented
    end
    if chord.include?('maj7')
      modifiers << :major_seventh
    end
    if MINOR_CHORD_REGEX.match?(chord)
      modifiers << :minor
    end
    if /\d/.match?(chord)
      modifiers << :number
    end
    { base: BASE_NOTE_REGEX.match(chord).to_s, chord: chord, modifiers: modifiers }
  end

  def self.get_lines_for_columns(song)
    lines = song.chord_sheet.split("\n")
    return lines, [] if lines.length <= MAX_LINES_PER_COL

    # find a good place to split the two columns
    midpoint = MAX_LINES_PER_COL
    until "blank" == get_class_for_line(lines[midpoint]) || lyric_line_far_from_blank?(midpoint, lines) do
      midpoint -= 1
    end
    return lines[0 .. midpoint], lines[midpoint + 1 .. -1]
  end

  def self.get_class_for_line(line)
    if line == ""
      "blank"
    elsif header_line? line
      "header"
    elsif chords_line? line
      "chord"
    else
      "lyric"
    end
  end

  def self.lyric_line_far_from_blank?(line_num, lines)
    return false if "lyric" != get_class_for_line(lines[line_num])
    # if this line is not too close to the end, and there is no blank too close, this lyric line is far enough
    line_num < lines.length - LINE_PADDING &&
      !(line_type_in_range?(line_num, "blank", LINE_PADDING, lines) || line_type_in_range?(line_num, "blank", -LINE_PADDING, lines))
  end


  def self.line_type_in_range?(line_num, line_type, range, lines)
    get_line_range(line_num, line_num + range, lines).each do |num|
      if (line_type == get_class_for_line(lines[num]))
        return true
      end
    end
    false
  end
  def self.get_line_range(start, ending, lines)
    if (ending < start)
      ([0, ending].max)..([start, lines.length-1].min)
    else
      ([0, start].max)..([ending, lines.length-1].min)
    end
  end

end
