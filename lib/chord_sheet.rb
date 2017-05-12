class ChordSheet
  attr_reader :chord_sheet
  attr_reader :key

  def initialize(chord_sheet, key)
    @chord_sheet = chord_sheet
    @key = key
  end

  def as_nashville_format
    new_sheet = chord_sheet
      .each_line
      .map { |line| format_line_nashville(line) }
      .join

    self.class.new(new_sheet, key)
  end

  def transpose(new_key)
    old_key_index = Music::CHROMATICS.index(Music::CHROMATICS.detect {|note| note.kind_of?(Array) ? note.include?(key) : (note == key)})
    new_key_index = Music::CHROMATICS.index(Music::CHROMATICS.detect {|note| note.kind_of?(Array) ? note.include?(new_key) : (note == new_key)})
    half_steps = new_key_index - old_key_index

    new_sheet = chord_sheet
      .each_line
      .map { |line| transpose_line(line, half_steps) }
      .join

    self.class.new(new_sheet, new_key)
  end

  private

  def format_line_nashville(line)
    return line unless Parser::chords_line?(line)

    line.gsub(Parser::CHORD_TOKENIZER) { |chord| format_chord_nashville(chord) }
  end

  def format_chord_nashville(chord)
    parsed_chord = Parser::parse_chord(chord)

    roman_numeral = if Music::accidental_for_key?(key, parsed_chord[:base])
      format_accidental_nashville(parsed_chord[:base])
    else
      Music::ROMAN_NUMERALS[Music::get_note_scale_index(parsed_chord[:base], key)]
    end

    formatted_chord = parsed_chord[:chord].sub(parsed_chord[:base], roman_numeral)
    if parsed_chord[:modifiers].include?(:minor) || parsed_chord[:modifiers].include?(:diminished)
      formatted_chord.downcase!
      formatted_chord.sub!(Parser::MINOR_CHORD_REGEX, '')
      formatted_chord.sub!('dim', '')
    end

    formatted_chord
  end

  def format_accidental_nashville(note)
    # get note in original key
    note_in_key = Music::get_note_in_key(key, note)
    # is the accidental sharper or flatter than note_in_key
    sharper = Music::sharper?(note, note_in_key)
    # transpose the note_in_key by half_steps
    roman_numeral_in_key = Music::ROMAN_NUMERALS[Music::get_note_scale_index(note_in_key, key)]
    # then sharpen/flatten as accidental was sharper/flatter than note_in_key
    sharper ? Music::sharpen(roman_numeral_in_key) : Music::flatten(roman_numeral_in_key)
  end

  def transpose_line(line, half_steps)
    return line unless Parser::chords_line?(line)

    line.gsub(Parser::CHORD_TOKENIZER) { |chord| transpose_chord(chord, half_steps) }
  end

  def transpose_chord(chord, half_steps)
    parsed_chord = Parser::parse_chord(chord)
    if Music::accidental_for_key?(key, parsed_chord[:base])
      new_base_note = transpose_accidental(parsed_chord[:base], half_steps)
    else
      new_note_index = (Music::get_note_index(parsed_chord[:base]) + half_steps) % 12
      new_base_note = Music::CHROMATICS[new_note_index]
      new_key = Music::MAJOR_KEYS[(Music::MAJOR_KEYS.index(key) + half_steps) % 12]
      new_base_note = new_base_note.kind_of?(Array) ? Music::which_note_in_key(new_base_note, new_key) : new_base_note # account for enharmonic equivalents
    end

    parsed_chord[:chord].sub(parsed_chord[:base], new_base_note)
  end

  def transpose_accidental(note, half_steps)
    # get note in original key
    note_in_key = Music::get_note_in_key(key, note)
    # is the accidental sharper or flatter than note_in_key
    sharper = Music::sharper?(note, note_in_key)
    # transpose the note_in_key by half_steps
    transposed_in_key = transpose_chord(note_in_key, half_steps)
    # then sharpen/flatten as accidental was sharper/flatter than note_in_key
    sharper ? Music::sharpen(transposed_in_key) : Music::flatten(transposed_in_key)
  end
end