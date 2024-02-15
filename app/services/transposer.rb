# frozen_string_literal: true

module Transposer
  def self.transpose_song(song, new_key)
    old_key = song.key
    old_key_index = Music::CHROMATICS.index(Music::CHROMATICS.detect do |note|
                                              note.is_a?(Array) ? note.include?(old_key) : (note == old_key)
                                            end)
    new_key_index = Music::CHROMATICS.index(Music::CHROMATICS.detect do |note|
                                              note.is_a?(Array) ? note.include?(new_key) : (note == new_key)
                                            end)
    half_steps = new_key_index - old_key_index
    new_chord_sheet_list = []
    song.chord_sheet.each_line do |line|
      new_chord_sheet_list << transpose_line(line, half_steps, old_key)
    end

    song.chord_sheet = new_chord_sheet_list.join
    song.key = new_key
  end

  def self.transpose_line(line, half_steps, old_key)
    return line unless Parser.chords_line?(line)

    line.gsub(Parser::CHORD_TOKENIZER) do |chord|
      transpose_chord(chord, half_steps, old_key)
    end
  end

  def self.transpose_chord(chord, half_steps, old_key)
    parsed_chord = Parser.parse_chord(chord)
    if Music.accidental_for_key?(old_key, parsed_chord[:base])
      new_base_note = transpose_accidental(parsed_chord[:base], half_steps, old_key)
    else
      new_note_index = (Music.get_note_index(parsed_chord[:base]) + half_steps) % 12
      new_base_note = Music::CHROMATICS[new_note_index]
      new_key = Music::MAJOR_KEYS[(Music::MAJOR_KEYS.index(old_key) + half_steps) % 12]
      new_base_note = new_base_note.is_a?(Array) ? Music.which_note_in_key(new_base_note, new_key) : new_base_note # account for enharmonic equivalents
    end

    parsed_chord[:chord].sub(parsed_chord[:base], new_base_note)
  end

  def self.transpose_accidental(note, half_steps, old_key)
    # get note in original key
    note_in_key = Music.get_note_in_key(old_key, note)
    # is the accidental sharper or flatter than note_in_key
    sharper = Music.sharper?(note, note_in_key)
    # transpose the note_in_key by half_steps
    transposed_in_key = transpose_chord(note_in_key, half_steps, old_key)
    # then sharpen/flatten as accidental was sharper/flatter than note_in_key
    sharper ? Music.sharpen(transposed_in_key) : Music.flatten(transposed_in_key)
  end
end
