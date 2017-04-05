# based off of https://gist.github.com/andrewstucki/106c9704be9233e197350ceabec6a32c
module Parser

  CHORD_REGEX = /^(\s*(([A-G1-9]?[#b]?(m|maj|dim)?(no|add|s|sus|aug)?\d*)|:\]|\[:|:?\|:?|-|\/|\}|\(|\))\s*)+$/
  CHORD_INCLUDE_INVERSION_TOKENIZER = /(?:(?:[A-G](?:b)?(?:#)?(?:|maj|m|dim)?(?:|s|sus|aug)*[\d]*)\(?(?:b)?(?:#)?[\d]*?\)?)\/?(?:(?:[A-G](?:b)?(?:#)?(?:|maj|m|dim)?(?:|s|sus|aug)*[\d]*)\(?(?:b)?(?:#)?[\d]*?\)?)?(?=\s|$)(?!\w)/
  CHORD_TOKENIZER = /(?:(?:[A-G](?:b)?(?:#)?(?:|maj|m|dim)?(?:|s|sus|aug)*[\d]*)\(?(?:b)?(?:#)?[\d]*?\)?\(?(?:b)?(?:#)?[\d]*?\)?)(?=\/|\s|$)/
  BASE_REGEX = /[A-G][b#]?/
  MINOR_CHORD = /(?<!di)m(?!aj)/

  def self.chords_line?(line)
    line =~ CHORD_REGEX
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
    if chord =~ MINOR_CHORD
      modifiers << :minor
    end
    if  chord =~ /\d/
      modifiers << :number
    end
    { base: BASE_REGEX.match(chord).to_s, chord: chord, modifiers: modifiers }
  end

end