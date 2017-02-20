def is_header_line(line)
  line.start_with?("Title:") ||
    line.start_with?("Arist:") ||
    line.start_with?("Suggested Key:") ||
    line.start_with?("Tempo:") ||
    line.start_with?("Standard Scan:")
end

namespace :songsheets do

  desc 'Check line lengths of all the song sheets in a directory.'
  task :check_line_lengths, [:directory_path] => :environment do |t, args|
    # make sure directory_path is a valid directory
    abort("Must specify directory_path.") if args.directory_path.nil?
    abort("\"#{args.directory_path}\" does not exist or is not a directory.") unless File.directory?(args.directory_path)
    directory_path = args.directory_path.chomp("/")

    # check line lengths of all .txt files in the specified directory
    max_line_length = Song::MAX_LINE_LENGTH
    num_lines_too_long = 0
    Dir.glob("#{directory_path}/*.txt") do |song_file|
      lines_too_long = []
      IO.readlines(song_file).each_with_index do |line, line_index|
        if not is_header_line(line)
          if line.length > max_line_length
            lines_too_long << (line_index + 1)
          end
        end
      end
      if lines_too_long.any?
        puts "#{File.basename(song_file, '.txt')}"
        lines_too_long.reverse.each do |line_number|
          # print line numbers bottom up so as lines are split in two, the next line numbers are not affected
          puts "\t#{line_number}"
        end
        num_lines_too_long += lines_too_long.length
      end
    end
    puts "Done. There were #{num_lines_too_long} lines over #{max_line_length} chars long."
  end
end