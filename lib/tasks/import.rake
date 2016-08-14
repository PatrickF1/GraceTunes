namespace :songs do
  desc 'Song: Parse a song sheet or directory of song sheets and add to database'
  task import: :environment do
    PG_INDEX_SIZE_LIMIT = 2712
    VALID_OPTS = ['file=FILE_NAME', 'dir=DIR_NAME', 'recursive=[true|false]']
    options = OpenStruct.new
    options.file = ENV['file'] || ''
    options.dir = ENV['dir'] || ''
    options.recursive = ENV['recursive'] == 'true' ? true : false

    if options.file.present?
      song = SongUtils::SongNormalizer.new(options.file).normalized_song
      song.save!
    elsif options.dir.present?
      search_str = "#{options.dir}/*"
      serach_str << '*' if options.recursive

      parse_songs_in_dir(search_str)
      puts "Done!".green
    else
      puts "Options are: #{VALID_OPTS.join(' ')}"
    end
  end

  def parse_songs_in_dir(dir)
    songs = []
    files_invalid = []
    files_too_large = []
    files_unsupported = []

    songs_found = Dir.glob(File.expand_path(dir))
    puts "Found #{songs_found.length} songs in directory.".green

    songs_found.each do |file|
      next if File.directory?(file)

      filename = File.basename(file)
      puts "Parsing '#{filename}'".yellow

      begin
        song = SongUtils::SongNormalizer.new(file).normalized_song
      rescue ::SongUtils::SongNormalizer::UnsupportedFileType => e
        files_unsupported << filename
        next
      end

      if song.valid?
        if song.song_sheet.length > PG_INDEX_SIZE_LIMIT
          files_too_large << filename
          next
        end

        songs << song.as_json
      else
        files_invalid << filename
      end

      if songs.length % 50 == 0
        Song.create!(songs)
        songs = []
      end
    end

    Song.create!(songs) if songs.any?
    puts "\nThe following files could not be parsed: \n\t#{files_invalid.join("\n\t").cyan}".red
    puts "\nThe following files were too large: \n\t#{files_too_large.join("\n\t").cyan}".red
    puts "\nThe following files had unsupported mime types: \n\t#{files_unsupported.join("\n\t").cyan}".red
  rescue => e
    puts "Unexepected error: #{e.message}".red
    exit
  end
end
