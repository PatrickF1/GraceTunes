module Music
  CHROMATICS = ['A', ['A#','Bb'], ['B', 'Cb'], ['B#', 'C'], ['C#','Db'], 'D', ['D#','Eb'], ['E', 'Fb'], ['E#', 'F'], ['F#','Gb'], 'G', ['G#','Ab']].freeze
  MAJOR_KEYS = ['Ab', 'A', 'Bb', 'B', 'C', 'Db', 'D', 'Eb', 'E', 'F', 'F#', 'G'].freeze # use Db, F#, B for 3 enharmonic equivalent keys
  MAJOR_STEPS = [0, 2, 2, 1, 2, 2, 2].freeze
  MAJOR_INTERVALS = [0, 2, 4, 5, 7, 9, 11].freeze
  ROMAN_NUMERALS = {
    1 => "I",
    2 => "II",
    3 => "III",
    4 => "IV",
    5 => "V",
    6 => "VI",
    7 => "VII"
  }

  def self.key_has_note?(key, note)
    MAJOR_SCALES[key].find { |n| n[:base] == note }.present?
  end

  def self.get_note_index(note)
    CHROMATICS.index(CHROMATICS.detect {|n| n.kind_of?(Array) ? n.include?(note) : (n == note)})
  end

  def self.get_note_scale_index(note, key)
    MAJOR_SCALES[key].each_with_index { |scale_note, index| return index + 1 if scale_note[:base] == note }
  end

  def self.which_note_in_key(note_array, key)
    note_array.find { |note| key_has_note?(key, note) }
  end

  # takes any form of a note and returns the note in the given key
  def self.get_note_in_key(key, note)
    MAJOR_SCALES[key].find { |n| get_natural(n[:base]) == get_natural(note) }[:base]
  end

  def self.accidental_for_key?(key, note)
    !key_has_note?(key, note)
  end

  def self.get_natural(note)
    /[A-G]/.match(note).to_s
  end

  def self.sharpen(note, number = false)
    if natural?(note) || number
      note.to_s + "#"
    elsif flat?(note)
      get_natural(note)
    else
      new_chromatic = CHROMATICS[(get_note_index(note) + 1) % 12]
      new_chromatic.kind_of?(Array) ? new_chromatic[0] : new_chromatic # get lower of the next chromatic
    end
  end

  def self.flatten(note, number = false)
    if natural?(note) || number
      note.to_s + "b"
    elsif sharp?(note)
      get_natural(note)
    else
      new_chromatic = CHROMATICS[(get_note_index(note) - 1) % 12]
      new_chromatic.kind_of?(Array) ? new_chromatic[1] : new_chromatic # get higher of the previous chromatic
    end
  end

  # is note1 sharper than note2, must be same letter
  def self.sharper?(note1, note2)
    (flat?(note2) && (natural?(note1) || sharp?(note1))) ||
      (natural?(note2) && sharp?(note1))
  end

  # is note 1 flatter than note2, must be same letter
  def self.flatter?(note1, note2)
    (flat?(note1) && (natural?(note2) || sharp?(note2))) ||
      (natural?(note1) && sharp?(note2))
  end

  def self.sharp?(note)
    note =~ /#/
  end

  def self.flat?(note)
    note =~ /b/
  end

  def self.natural?(note)
    !(note =~ /[b#]/)
  end

  # needs to be after method definitions
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
        natural_last_note = get_natural(scale.last[:base])
        next_note = chromatic.each do |possible_note|
          natural_possible_note = get_natural(possible_note)
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

end