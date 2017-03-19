# based off of https://gist.github.com/andrewstucki/106c9704be9233e197350ceabec6a32c

class Parser
  CHROMATICS = ['A', ['A#','Bb'], ['B', 'Cb'], ['B#', 'C'], ['C#','Db'], 'D', ['D#','Eb'], ['E', 'Fb'], ['E#', 'F'], ['F#','Gb'], 'G', ['G#','Ab']].freeze
  MAJOR_KEYS = ['Ab', 'A', 'Bb', 'B', 'C', 'Db', 'D', 'Eb', 'E', 'F', 'F#', 'G'].freeze # use Db, F#, B for 3 enharmonic equivalent keys
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

  CHORD_REGEX = /^(\s*(([A-G1-9]?[#b]?(m|M|maj|dim)?(no|add|s|sus)?\d*)|:\]|\[:|:?\|:?|-|\/|\}|\(|\))\s*)+$/
  CHORD_TOKENIZER = /\s*\(?([A-G1-9][#b]?\/[A-G1-9][#b]?)|(([A-G1-9][#b]?(m|M|maj|dim)?)\d*)\)?\s*/

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
          sheet << {type: :chords, content: new_chords, parsed: chords(new_chords)}
        end
      end
      sheet
    end
    dump_sheet(new_sheet)
  end

  def guess_key!
    @key ||= begin
      chords = @chords.keys
      counts = MAJOR_SCALES.keys.map do |key|
        scale = MAJOR_SCALES[key]
        key_matches = 0
        chords.each do |chord|
          in_scale = scale_has_chord?(scale, chord)
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

  end

  private

  def parse_sheet!
    @parsed_sheet = begin
      parsed_sheet = []
      parsed_chords = []
      key_change = false
      @chord_sheet.each_line do |line|
        chords = chords(line)
        key_change = true if line =~ /KEY (UP|DOWN)/
        parsed_sheet << (chords ? { type: :chords, content: line, parsed: chords } : { type: :lyrics, content: line })
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
    return transpose_accidental(half_steps, token) if accidental_for_key?(@key, token)
    new_note_index = (get_note_index(token) + half_steps) % 12
    new_token = CHROMATICS[new_note_index]
    new_key = MAJOR_KEYS[(MAJOR_KEYS.index(@key) + half_steps) % 12]
    new_token.kind_of?(Array) ? which_note_in_key(new_token, new_key) : new_token
  end

  def transpose_accidental(half_steps, note)
    # get note in original key
    note_in_key = get_note_in_key(@key, note)
    # is the accidental sharper or flatter than note_in_key
    sharper = sharper?(note, note_in_key)
    # transpose the note_in_key by half_steps
    transposed_in_key = transpose_token(half_steps, note_in_key)
    # then sharpen/flatten as accidental was sharper/flatter than note_in_key
    sharper ? sharpen(transposed_in_key) : flatten(transposed_in_key)
  end

  def dump_sheet(sheet)
    sheet.map { |line| line[:content] }.join
  end

  # Chord utility methods #####################################################

  def chords(line)
    return nil unless self.class.chords?(line)
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

  # Note utility methods ######################################################

  def key_has_note?(key, note)
    MAJOR_SCALES[key].find { |n| n[:base] == note }.present?
  end

  def get_note_index(note)
    CHROMATICS.index(CHROMATICS.detect {|n| n.kind_of?(Array) ? n.include?(note) : (n == note)})
  end

  def which_note_in_key(note_array, key)
    note_array.find { |note| key_has_note?(key, note) }
  end

  # takes any form of a note and returns the note in the given key
  def get_note_in_key(key, note)
    MAJOR_SCALES[key].find { |n| get_natural(n[:base]) == get_natural(note) }[:base]
  end

  def accidental_for_key?(key, note)
    !key_has_note?(key, note)
  end

  def get_natural(note)
    /[A-G]/.match(note).to_s
  end

  def sharpen(note)
    if flat?(note)
      get_natural(note)
    elsif natural?(note)
      note + "#"
    else
      CHROMATICS[(get_note_index(note) + 1) % 12][0] # get lower of the next chromatic
    end
  end

  def flatten(note)
    if sharp?(note)
      get_natural(note)
    elsif natural?(note)
      note + "b"
    else
      CHROMATICS[(get_note_index(note) - 1) % 12][1] # get higher of the previous chromatic
    end
  end

  # is note1 sharper than note2, must be same letter
  def sharper?(note1, note2)
    (flat?(note2) && (natural?(note1) || sharp?(note1))) ||
      (natural?(note2) && sharp?(note1))
  end

  # is note 1 flatter than note2, must be same letter
  def flatter?(note1, note2)
    (flat?(note1) && (natural?(note2) || sharp?(note2))) ||
      (natural?(note1) && sharp?(note2))
  end

  def sharp?(note)
    note =~ /#/
  end

  def flat?(note)
    note =~ /b/
  end

  def natural?(note)
    !(note =~ /[b#]/)
  end

end