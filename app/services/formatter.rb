module Formatter

  def self.format_song_nashville(song)
    new_chord_sheet_list = []
    song.chord_sheet.each_line do |line|
      new_chord_sheet_list << format_line_nashville(line, song.key)
    end

    song.chord_sheet = new_chord_sheet_list.join
  end

  def self.format_line_nashville(line, key)
    if !Parser::chords_line?(line)
      return line
    end

    line.gsub(Parser::CHORD_TOKENIZER) do |chord|
      format_chord_nashville(chord, key)
    end
  end

  def self.format_chord_nashville(chord, key)
    parsed_chord = Parser::parse_chord(chord)
    if Music::accidental_for_key?(key, parsed_chord[:base])
      return chord + "// accidental //"
    end
    roman_numeral = Music::ROMAN_NUMERALS[Music::get_note_scale_index(parsed_chord[:base], key)]
    formatted_chord = parsed_chord[:chord].sub(parsed_chord[:base], roman_numeral)
    if parsed_chord[:modifiers].include? :minor
      formatted_chord.downcase!
      formatted_chord.sub!(Parser::MINOR_CHORD, '')
    end
    formatted_chord
  end
end