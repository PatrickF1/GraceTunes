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

  def self.remove_minors(line)
    line.gsub!(/m(?!aj)/, '')
  end

  def self.super_script_numbers(line)
    line.gsub!(/((?<=\d)\d\b)/, '<sup>\1</sup>')
  end
end