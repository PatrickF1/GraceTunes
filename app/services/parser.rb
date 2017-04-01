# based off of https://gist.github.com/andrewstucki/106c9704be9233e197350ceabec6a32c
class Parser

  attr_reader :chord_sheet, :chords_nums_by_chord, :key, :parsed_sheet, :parsed_chords

  CHORD_REGEX = /^(\s*(([A-G1-9]?[#b]?(m|maj|dim)?(no|add|s|sus|aug)?\d*)|:\]|\[:|:?\|:?|-|\/|\}|\(|\))\s*)+$/
  CHORD_INCLUDE_INVERSION_TOKENIZER = /(?:(?:[A-G](?:b)?(?:#)?(?:|maj|m|dim)?(?:|s|sus|aug)*[\d]*)\(?(?:b)?(?:#)?[\d]*?\)?)\/?(?:(?:[A-G](?:b)?(?:#)?(?:|maj|m|dim)?(?:|s|sus|aug)*[\d]*)\(?(?:b)?(?:#)?[\d]*?\)?)?(?=\s|$)(?!\w)/
  CHORD_TOKENIZER = /(?:(?:[A-G](?:b)?(?:#)?(?:|maj|m|dim)?(?:|s|sus|aug)*[\d]*)\(?(?:b)?(?:#)?[\d]*?\)?\(?(?:b)?(?:#)?[\d]*?\)?)(?=\/|\s|$)/
  BASE_REGEX = /[A-G][b#]?/
  MINOR_CHORD = /(?<!di)m(?!aj)/

  def initialize(sheet, key = nil)
    @chord_sheet = sheet
    @chord_nums_by_chord = Hash.new(0) # hash  of { chord => count of that chord }
    @key = key if key
    @parsed_sheet = [] # list of lines [ { :type, :content, :parsed } ]
    @parsed_chords = [] # list of all chords in order, with their modifiers [ { :chord, :modifiers } ]
    byebug
    parse_sheet!
    guess_key! unless key || (key == false)
  end

  def statistics
    total = @chord_nums_by_chord.values.reduce(0, :+)
    @key_stats.map do |stat|
      short_key = stat[:key].kind_of?(Array) ? stat[:key][1] : stat[:key]
      "#{short_key}: #{stat[:matches]/total.to_f * 100}%"
    end.join("\n")
  end

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

  private

  def parse_sheet!
    @parsed_sheet = begin
      parsed_sheet = []
      @chord_sheet.each_line do |line|
        chords = self.class.chords_from_line(line)
        parsed_sheet << (!chords.empty? ? { type: :chords, content: line, parsed: chords } : { type: :lyrics, content: line })
        @parsed_chords += chords if chords
      end
      @parsed_chords = parsed_chords.map {|chord| parse_chord(chord) }
      @parsed_chords.each { |chord| @chord_nums_by_chord.store(chord, @chord_nums_by_chord[chord]+1) } # Ruby lets us use objects as keys...
      parsed_sheet
    end
  end

  def guess_key!
    @key ||= begin
      chords = @chord_nums_by_chord.keys
      counts = Music::MAJOR_SCALES.keys.map do |key|
        scale = Music::MAJOR_SCALES[key]
        key_matches = 0
        chords.each do |chord|
          in_scale = Music::scale_has_chord?(scale, chord)
          key_matches += @chord_nums_by_chord[chord] if in_scale # accumulate the total number of chords in the song that match this key
        end
        { key: key, matches: key_matches }
      end
      @key_stats = counts.sort_by {|count| count[:matches]}.reverse
      key = @key_stats.first[:key]
      key.kind_of?(Array) ? key[1] : key
    end
  end

end