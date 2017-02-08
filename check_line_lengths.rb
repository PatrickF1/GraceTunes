PADDING = "  "

def is_header_line(line)
  line.start_with?("Title:") ||
    line.start_with?("Arist:") ||
    line.start_with?("Suggested Key:") ||
    line.start_with?("Tempo:") ||
    line.start_with?("Standard Scan:")
end

Dir.glob('/Users/patrick/Downloads/GraceTunesSongs/*.txt') do |song_file|
  lines_too_long = []
  IO.readlines(song_file).each_with_index do |line, line_index|
    if not is_header_line(line)
      if line.length > 50
        lines_too_long << (line_index + 1)
      end
    end
  end
  if lines_too_long.any?
    puts "#{File.basename(song_file)}"
    lines_too_long.reverse.each do |line_number|
      puts "#{PADDING}#{line_number}"
    end
  end
end

