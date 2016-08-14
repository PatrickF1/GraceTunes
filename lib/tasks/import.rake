require './lib/song_utils/song_normalizer'

namespace :songs do
  desc 'Song: Parse a song sheet or directory of song sheets and add to database'
  task import: :environment do
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

      songs = []
      invalid_files = []
      too_large = []
      PG_INDEX_SIZE_LIMIT = 2712
      begin
        parse_dir(search_str)
      rescue => e
        byebug
        puts "#{e.message}".red
      end

      puts "The following files could not be parsed: \n\t#{invalid_files.join("\n").cyan}".red
      puts "The following files were too large: \n\t#{too_large.join("\n").cyan}".red
      puts "Done!".green
    else
      puts "Options are: #{VALID_OPTS.join(' ')}"
    end

    def parse_dir(dir)
      songs_found = Dir.glob(File.expand_path(search_str))
      puts "Found #{songs_found.length} songs in directory.".green

      songs_found.each do |file|
        filename = File.basename(file)
        puts "Parsing '#{filename}'".yellow
        song = SongUtils::SongNormalizer.new(file).normalized_song

        if song.valid?
          if song.song_sheet.length > PG_INDEX_SIZE_LIMIT
            too_large << filename
            next
          end

          songs << song.as_json
        else
          invalid_files << filename
        end

        if songs.length % 50 == 0
          Song.create!(songs)
          songs = []
        end
      end

      Song.create!(songs) if songs.any?
    end
  end
end
