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

    space_slice_args = [] # list of pairs of string::slice args to delete spaces for chord size differences

    line.gsub!(Parser::CHORD_TOKENIZER) do |chord|
      formatted_chord = format_chord_nashville(chord, key)
      formatted_chord_length_difference = formatted_chord.length - chord.length
      if formatted_chord_length_difference < 0
        formatted_chord += " " * (chord.length - formatted_chord.length)
      elsif formatted_chord_length_difference > 0
        after_chord_index = Regexp.last_match.offset(0)[1] + formatted_chord_length_difference
        num_spaces_to_delete = get_num_spaces_can_delete(line, after_chord_index, formatted_chord_length_difference)
        if num_spaces_to_delete > 0
          space_slice_args << [after_chord_index, num_spaces_to_delete]
        end
      end
      formatted_chord
    end

    space_slice_args.each do |slice_args|
      line.slice!(slice_args[0], slice_args[1])
    end
    line
  end

  def self.format_chord_nashville(chord, key)
    parsed_chord = Parser::parse_chord(chord)
    roman_numeral = Music::accidental_for_key?(key, parsed_chord[:base]) ? format_accidental_nashville(parsed_chord[:base], key)
        : Music::ROMAN_NUMERALS[Music::get_note_scale_index(parsed_chord[:base], key)]

    formatted_chord = parsed_chord[:chord].sub(parsed_chord[:base], roman_numeral)
    if parsed_chord[:modifiers].include?(:minor) || parsed_chord[:modifiers].include?(:diminished)
      formatted_chord.downcase!
      formatted_chord.sub!(Parser::MINOR_CHORD_REGEX, '')
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
    sharper ? Music::sharpen(roman_numeral_in_key) : Music::flatten(roman_numeral_in_key)
  end

  def self.get_num_spaces_can_delete(line, start_index, max_num_to_delete)
    char_range = line[start_index..-1]
    if char_range.nil?
      return 0
    end
    count = 0
    char_range.each_char do |char|
      if char == " "
        count += 1
        if count == max_num_to_delete
          return count
        end
      else
        return count - 1
      end
    end
    count
  end
end