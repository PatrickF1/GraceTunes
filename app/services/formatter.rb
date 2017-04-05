module Formatter

  def self.format_song_nashville(song)
    new_chord_sheet_list = []
    song.chord_sheet.each_line do |line|
      new_chord_sheet_list << format_line_nashville(line, song.key)
    end

    song.chord_sheet = new_chord_sheet_list.join
  end

  private

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
    roman_numeral = Music::accidental_for_key?(key, parsed_chord[:base]) ? format_accidental_nashville(parsed_chord[:base], key)
        : Music::ROMAN_NUMERALS[Music::get_note_scale_index(parsed_chord[:base], key)]

    formatted_chord = parsed_chord[:chord].sub(parsed_chord[:base], roman_numeral)
    if parsed_chord[:modifiers].include?(:minor) || parsed_chord[:modifiers].include?(:diminished)
      formatted_chord.downcase!
      formatted_chord.sub!(Parser::MINOR_CHORD, '')
      formatted_chord.sub!('dim', '')
    end
    formatted_chord
  end

  def self.format_accidental_nashville(note, key)
    # get note in original key
    note_in_key = Music::get_note_in_key(key, note)
    # is the accidental sharper or flatter than note_in_key
    sharper = Music::sharper?(note, note_in_key)
    # transpose the note_in_key by half_steps
    roman_numeral_in_key = Music::ROMAN_NUMERALS[Music::get_note_scale_index(note_in_key, key)]
    # then sharpen/flatten as accidental was sharper/flatter than note_in_key
    sharper ? Music::sharpen(roman_numeral_in_key, true) : Music::flatten(roman_numeral_in_key, true)
  end
end