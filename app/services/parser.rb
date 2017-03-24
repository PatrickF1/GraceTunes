# based off of https://gist.github.com/andrewstucki/106c9704be9233e197350ceabec6a32c
class Parser

  attr_reader :chord_sheet, :chords, :key, :parsed_sheet

  CHORD_REGEX = /^(\s*(([A-G1-9]?[#b]?(m|M|maj|dim)?(no|add|s|sus)?\d*)|:\]|\[:|:?\|:?|-|\/|\}|\(|\))\s*)+$/
  CHORD_TOKENIZER = /(?:(?:[A-G](?:b)?(?:#)?(?:|sus|maj|M|min|m|aug)*[\d]*)\(?(?:b)?(?:#)?[\d]*?\)?)\/?(?:(?:[A-G](?:b)?(?:#)?(?:|sus|maj|M|min|m|aug)*[\d]*)\(?(?:b)?(?:#)?[\d]*?\)?)?(?=\s|$)(?!\w)/

  def initialize(sheet, key = nil)
    @chord_sheet = sheet
    @chords = Hash.new(0) # hash  of { chord => count of that chord }
    @key = key if key
    @parsed_sheet = [] # list of lines [ { :type, :content } ]
    parse_sheet!
    guess_key! unless key || (key == false)
  end

  def statistics
    total = @chords.values.reduce(0, :+)
    @key_stats.map do |stat|
      short_key = stat[:key].kind_of?(Array) ? stat[:key][1] : stat[:key]
      "#{short_key}: #{stat[:matches]/total.to_f * 100}%"
    end.join("\n")
  end

  def self.chords?(line)
    line =~ CHORD_REGEX
  end

  def self.header?(line)
    line[-1] == ":"
  end

  def self.lyrics?(line)
    !line.strip.empty? && !chords?(line) && !header?(line)
  end

  def self.chords_from_line(line)
    return [] unless chords?(line)
    line.scan CHORD_TOKENIZER
  end

  def self.dump_sheet(sheet)
    sheet.map { |line| line[:content] }.join
  end

  private

  def parse_sheet!
    @parsed_sheet = begin
      parsed_sheet = []
      parsed_chords = []
      key_change = false
      @chord_sheet.each_line do |line|
        chords = self.class.chords_from_line(line)
        key_change = true if line =~ /KEY (UP|DOWN)/
        parsed_sheet << (!chords.empty? ? { type: :chords, content: line, parsed: chords } : { type: :lyrics, content: line })
        parsed_chords += chords if chords && !key_change
      end
      numbers = parsed_chords.any? {|chord| chord =~ /\d/ }
      letters = parsed_chords.any? {|chord| chord =~ /[A-Z]/ }
      parsed_chords = (numbers && letters) ? parsed_chords.select {|chord| chord =~ /[A-Z]/} : parsed_chords
      formatted_chords = parsed_chords.map {|chord| format_chord(chord) }
      formatted_chords.each { |chord| @chords.store(chord, @chords[chord]+1) } # Ruby lets us use objects as keys...
      parsed_sheet
    end
  end

  def guess_key!
    @key ||= begin
      chords = @chords.keys
      counts = Music::MAJOR_SCALES.keys.map do |key|
        scale = Music::MAJOR_SCALES[key]
        key_matches = 0
        chords.each do |chord|
          in_scale = Music::scale_has_chord?(scale, chord)
          key_matches += @chords[chord] if in_scale # accumulate the total number of chords in the song that match this key
        end
        { key: key, matches: key_matches }
      end
      @key_stats = counts.sort_by {|count| count[:matches]}.reverse
      key = @key_stats.first[:key]
      key.kind_of?(Array) ? key[1] : key
    end
  end

  # Chord utility methods #####################################################

  def format_chord(chord)
    modifier = case
    when chord.include?('dim')
      chord.slice! 'dim'
      :diminished
    when chord.include?('m')
      chord.slice! 'm'
      :minor
    when chord.include?('M') # drop the major
      chord.slice! 'M'
      nil
    when chord.include?('/') # slash chord
      chord = chord.split("/")
      :inversion
    else
      nil
    end
    { base: chord, modifier: modifier }
  end

end