# based off of https://gist.github.com/andrewstucki/106c9704be9233e197350ceabec6a32c

class Parser
  CHROMATICS = ['A', ['A#','Bb'], ['B', 'Cb'], ['B#', 'C'], ['C#','Db'], 'D', ['D#','Eb'], ['E', 'Fb'], ['E#', 'F'], ['F#','Gb'], 'G', ['G#','Ab']].freeze
  MAJOR_KEYS = ['Ab', 'A', 'Bb', 'B', 'C', 'C#', 'D', 'Eb', 'E', 'F', 'F#', 'G'].freeze # choose sharp versions of 3 enharmonic equivalent keys
  MAJOR_STEPS = [0, 2, 2, 1, 2, 2, 2].freeze
  MAJOR_INTERVALS = [0, 2, 4, 5, 7, 9, 11].freeze

  # { key => scale }
  MAJOR_SCALES = MAJOR_KEYS.each_with_index.map do |key, index|
    scale = []
    offset = CHROMATICS.index(CHROMATICS.detect {|note| note.kind_of?(Array) ? note.include?(key) : (note == key)})
    MAJOR_INTERVALS.each_with_index do |increment, interval_index|
      chromatic = CHROMATICS[(offset + increment) % 12]
      if !chromatic.kind_of?(Array)
        note = { base: chromatic }
      elsif chromatic.include? key
        note = { base: key }
      else
        natural_last_note = /[A-G]/.match(scale.last[:base]).to_s
        next_note = chromatic.each do |possible_note|
          natural_possible_note = /[A-G]/.match(possible_note).to_s
          break possible_note unless natural_possible_note == natural_last_note
        end
        note = { base: next_note }
      end

      note[:modifier] = :minor if [1, 2, 5].include? interval_index
      note[:modifier] = :diminished if interval_index == 6
      scale << note
    end
    [ key, scale ]
  end.to_h.freeze

  CHORD_REGEX = /^(\s*(([A-G1-9][#b]?(m|M|dim)?(no|add|s|sus)?\d*)|:\]|\[:|:?\|:?|-|\/|\}|\(|\))\s*)+$/
  CHORD_TOKENIZER = /\s*\(?([A-G1-9][#b]?\/[A-G1-9][#b]?)|(([A-G1-9][#b]?(m|M|dim)?)\d*)\)?\s*/

  attr_reader :chord_sheet, :chords, :key, :parsed_sheet

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

  def transpose_to(new_key)
    return dump_sheet(@parsed_sheet) if new_key.nil?
    integer = Integer(new_key) rescue false
    half_steps = integer if integer
    current_index = CHROMATICS.index(CHROMATICS.detect {|note| note.kind_of?(Array) ? note.include?(@key) : (note == @key)}) unless half_steps
    new_index = CHROMATICS.index(CHROMATICS.detect {|note| note.kind_of?(Array) ? note.include?(new_key) : (note == new_key)}) unless half_steps
    half_steps ||= new_index-current_index
    new_sheet = begin
      sheet = []
      @parsed_sheet.each do |line|
        if line[:type] == :lyrics
          sheet << line
        elsif line[:type] == :chords
          new_chords = transpose_line(half_steps, line[:content])
          sheet << {type: :chords, content: new_chords, parsed: self.class.chords(new_chords)}
        end
      end
      sheet
    end
    dump_sheet(new_sheet)
  end

  def highlight
    dump_sheet(@parsed_sheet)
  end

  def guess_key!
    @key ||= begin
      chords = @chords.keys
      counts = MAJOR_SCALES.keys.map do |key|
        scale = MAJOR_SCALES[key]
        key_matches = 0
        chords.each do |chord|
          in_scale = self.class.scale_has_chord?(scale, chord)
          key_matches += @chords[chord] if in_scale # accumulate the total number of chords in the song that match this key
        end
        { key: key, matches: key_matches }
      end
      @key_stats = counts.sort_by {|count| count[:matches]}.reverse
      key = @key_stats.first[:key]
      key.kind_of?(Array) ? key[1] : key
    end
  end

  class << self
    def chords?(line)
      line =~ CHORD_REGEX
    end

    def header?(line)
      line[-1] == ":"
    end

    def lyrics?(line)
      !line.strip.empty? && !chords?(line) && !header?(line)
    end

    def chords(line)
      return nil unless chords?(line)
      tokens = line.scan CHORD_TOKENIZER
      tokens.map{|m| m[0] || m[2]}.flatten.compact
    end

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

    def scale_has_chord?(scale, chord)
      scale = MAJOR_SCALES.keys.detect {|s| s == scale } if scale.kind_of?(String)
      return false unless scale
      chord = format_chord(chord) if chord.kind_of?(String)
      return false unless chord
      if chord[:base].kind_of?(Array) # slash chord
        chord[:base].all? do |note| # all notes are in the major
          scale.any? do |n|
            n[:base] == note || (n[:base].kind_of?(Array) && n[:base].include?(note))
          end
        end
      else
        scale.any? do |n| # chord is found in the scale with a proper major, minor, or diminished
          (n[:base] == chord[:base] || (n[:base].kind_of?(Array) && n[:base].include?(chord[:base]))) && chord[:modifier] == n[:modifier]
        end
      end
    end

    def scale_has_note?(scale, note)
      scale.find { |n| n[:base] == note }.present?
    end

    def get_note_index(note)
      CHROMATICS.index(CHROMATICS.detect {|n| n.kind_of?(Array) ? n.include?(note) : (n == note)})
    end

  end

  private

  def parse_sheet!
    @parsed_sheet = begin
      parsed_sheet = []
      parsed_chords = []
      key_change = false
      @chord_sheet.each_line do |line|
        chords = self.class.chords(line)
        key_change = true if line =~ /KEY (UP|DOWN)/
        parsed_sheet << (chords ? { type: :chords, content: line, parsed: chords } : { type: :lyrics, content: line })
        parsed_chords += chords if chords && !key_change
      end
      numbers = parsed_chords.any? {|chord| chord =~ /\d/ }
      letters = parsed_chords.any? {|chord| chord =~ /[A-Z]/ }
      parsed_chords = (numbers && letters) ? parsed_chords.select {|chord| chord =~ /[A-Z]/} : parsed_chords
      formatted_chords = parsed_chords.map {|chord| self.class.format_chord(chord) }
      formatted_chords.each { |chord| @chords.store(chord, @chords[chord]+1) } # Ruby lets us use objects as keys...
      parsed_sheet
    end
  end

  def transpose_line(half_steps, line)
    tokens = line.split("") # do this so that we can keep track of what we replace
    new_tokens = []
    tokens.each_with_index do |token, index|
      second_token = tokens[index + 1] unless index == tokens.length
      if ['b', '#'].include?(second_token)
        token += second_token
        tokens[index + 1] = ''
      end
      new_tokens << transpose_token(half_steps, token)
    end
    new_tokens.join("")
  end

  def transpose_token(half_steps, token)
    return token unless token =~ /[A-G]/
    new_note_index = (Parser.get_note_index(token) + half_steps) % 12
    new_token = CHROMATICS[new_note_index]
    new_key = MAJOR_KEYS[(MAJOR_KEYS.index(@key) + half_steps) % 12]
    new_token.kind_of?(Array) ? which_note_in_key(new_token, new_key) : new_token
  end

  def which_note_in_key(note_array, key)
    note_array.find { |note| Parser.scale_has_note?(MAJOR_SCALES[key], note) }
  end

  def dump_sheet(sheet)
    sheet.map { |line| line[:content] }.join
  end

end