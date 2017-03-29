module Transposer

  def self.transpose_song(song, new_key)
    if new_key == "numbers"
      transpose_to_numbers(song)
    else
      parser = Parser.new(song.chord_sheet, song.key)
      song.chord_sheet = Formatter::dump_sheet(transpose_to(parser, new_key))
      song.key = new_key
    end
  end

  def self.transpose_to_numbers(song)
    parser = Parser.new(song.chord_sheet, song.key)
    parsed_number_sheet = to_numbers(parser)
    song.chord_sheet = Formatter::format_sheet_for_numbers(parsed_number_sheet)
  end

  private

  def self.transpose_to(parser, new_key = nil)
    return parser.parsed_sheet if new_key.nil?
    return to_numbers(parser) if new_key == "numbers"
    old_key = parser.key
    integer = Integer(new_key) rescue false
    half_steps = integer if integer
    current_index = Music::CHROMATICS.index(Music::CHROMATICS.detect {|note| note.kind_of?(Array) ? note.include?(old_key) : (note == old_key)}) unless half_steps
    new_index = Music::CHROMATICS.index(Music::CHROMATICS.detect {|note| note.kind_of?(Array) ? note.include?(new_key) : (note == new_key)}) unless half_steps
    half_steps ||= new_index-current_index
    new_sheet = []
    parser.parsed_sheet.each do |line|
      if line[:type] == :lyrics
        new_sheet << line
      elsif line[:type] == :chords
        new_chords = transpose_line(old_key, half_steps, line[:content])
        new_sheet << {type: :chords, content: new_chords, parsed: Parser::chords_from_line(new_chords)}
      end
    end
    return new_sheet
  end

  private

  def self.transpose_line(old_key, half_steps, line, to_number = false)
    tokens = line.split("") # do this so that we can keep track of what we replace
    new_tokens = []
    tokens.each_with_index do |token, index|
      second_token = tokens[index + 1] unless index == tokens.length
      if ['b', '#'].include?(second_token)
        token += second_token
        tokens[index + 1] = ''
      end
      new_tokens << transpose_token(old_key, half_steps, token, to_number)
    end
    new_tokens.join("")
  end

  def self.transpose_token(old_key, half_steps, token, to_number = false)
    return token unless token =~ /[A-G]/
    return Music::MAJOR_SCALES[old_key].each_with_index { |note, index| return index+1 if note[:base] == token } if to_number
    return transpose_accidental(old_key, half_steps, token, to_number) if Music::accidental_for_key?(old_key, token)
    new_note_index = (Music::get_note_index(token) + half_steps) % 12
    new_token = Music::CHROMATICS[new_note_index]
    new_key = Music::MAJOR_KEYS[(Music::MAJOR_KEYS.index(old_key) + half_steps) % 12]
    new_token.kind_of?(Array) ? Music::which_note_in_key(new_token, new_key) : new_token
  end

  def self.transpose_accidental(old_key, half_steps, note, to_number = false)
    # get note in original key
    note_in_key = Music::get_note_in_key(old_key, note)
    # is the accidental sharper or flatter than note_in_key
    sharper = Music::sharper?(note, note_in_key)
    # transpose the note_in_key by half_steps
    transposed_in_key = transpose_token(old_key, half_steps, note_in_key, to_number)
    # then sharpen/flatten as accidental was sharper/flatter than note_in_key
    sharper ? Music::sharpen(transposed_in_key, to_number) : Music::flatten(transposed_in_key, to_number)
  end

  def self.to_numbers(parser)
    new_sheet = []
    parser.parsed_sheet.each do |line|
      if line[:type] == :lyrics
        new_sheet << line
      elsif line[:type] == :chords
        new_chords = transpose_line(parser.key, 0, line[:content], true)
        new_sheet << {type: :chords, content: new_chords, parsed: Parser::chords_from_line(new_chords)}
      end
    end
    return new_sheet
  end
end