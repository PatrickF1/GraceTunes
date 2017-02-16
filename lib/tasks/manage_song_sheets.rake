def is_header_line(line)
  line.start_with?("Title:") ||
    line.start_with?("Arist:") ||
    line.start_with?("Suggested Key:") ||
    line.start_with?("Tempo:") ||
    line.start_with?("Standard Scan:")
end

namespace :songsheets do
  #TODO: use environment variables instead
  desc 'Check line lengths of all the song sheets in a directory.'
  task :check_line_lengths, [:max_line_length, :directory_path] do |t, args|
    # process arguments
    abort("Must specify max_line_length.") if args.max_line_length.nil?
    begin
      max_line_length = Integer(args.max_line_length)
    rescue
      abort("max_line_length must be an integer")
    end
    abort("Must specify directory_path.") if args.directory_path.nil?
    abort("\"#{args.directory_path}\" does not exist or is not a directory.") unless File.directory?(args.directory_path)
    directory_path = args.directory_path.chomp("/")

    # check line lengths of all .txt files in the specified directory
    padding = "  "
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
        puts "#{File.basename(song_file)}"
        lines_too_long.reverse.each do |line_number|
          puts "#{padding}#{line_number}"
        end
        num_lines_too_long += lines_too_long.length
      end
    end
    puts "Done checking. There were #{num_lines_too_long} lines that were too long."
  end

  desc 'Load all the song sheets in a directory into the database.'
  task load_into_db: :environment do

  end
end