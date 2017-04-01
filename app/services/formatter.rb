module Formatter

  def self.dump_sheet(parsed_sheet)
    parsed_sheet.map { |line| line[:content] }.join
  end

  def self.format_sheet_for_numbers(parsed_sheet)
    text = []
    parsed_sheet.each do |line|
      text << format_line_for_numbers(line)[:content]
    end
    text.join
  end

  def self.format_line_for_numbers(line)
    if line[:type] != :chords
      return line
    end

    remove_minors(line[:content])
    super_script_numbers(line[:content])
    line
  end

  def self.format_sheet_roman_numerals(parser)
    parser.parsed_chords.each do |parsed_chord|
      roman_numeral = Music::MAJOR_SCALES[parser.key].each_with_index { |note, index| return index+1 if note[:base] == parsed_chord[:base] }
      if parsed_chord.modifiers.include? :minor
        roman_numeral.downcase!
      end


      parser[parsed_chord[:chord]] =
  end

  def self.format_line_roman_numerals(line)
    if line[:type] != chords
      return line
    end



  end

  def self.remove_minors(line)
    line.gsub!(/m(?!aj)/, '')
  end

  def self.super_script_numbers(line)
    line.gsub!(/((?<=\d)\d\b)/, '<sup>\1</sup>')
  end
end