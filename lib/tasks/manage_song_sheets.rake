def is_header_line(line)
  line.start_with?("Title:") ||
    line.start_with?("Arist:") ||
    line.start_with?("Suggested Key:") ||
    line.start_with?("Tempo:") ||
    line.start_with?("Standard Scan:")
end

namespace :songsheet do

  desc 'Check line lengths of a directory of song sheets'
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
    PADDING = "  "

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
          puts "#{PADDING}#{line_number}"
        end
      end
    end
    puts "Done checking."
  end

  desc 'Check line lengths of a directory of song sheets'
  task load_into_db: :environment do

  end
end