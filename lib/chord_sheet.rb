require 'services/parser'

class ChordSheet
  attr_reader :chord_sheet
  attr_reader :key

  def initialize(chord_sheet, key)
    @chord_sheet = chord_sheet
    @key = key
  end

  def as_nashville_format(other_key=nil)
    chord_sheet
      .each_line
      .map { |line| format_line_nashville(line, other_key.presence || key) }
      .join
  end

  private

  def format_line_nashville(line, key)
    return line unless Parser::chords_line?(line)

    line.gsub(Parser::CHORD_TOKENIZER) { |chord| format_chord_nashville(chord, key) }
  end

  def format_chord_nashville(chord, key)
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
end