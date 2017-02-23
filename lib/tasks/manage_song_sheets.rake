def song_name_from_path(song_path)
  "#{File.basename(song_path, '.yaml')}"
end

def serialize_song_sheets(directory_path, save_into_db=false)
  # make sure directory_path is a valid directory
  abort("Must specify directory_path.") if directory_path.nil?
  abort("\"#{directory_path}\" does not exist or is not a directory.") unless File.directory?(directory_path)
  directory_path = directory_path.chomp("/")

  # parse all the .yaml files in the specified directory and print out any errors
  num_invalid_songs = 0
  Dir.glob("#{directory_path}/*.yaml") do |song_path|
    begin
      song_file = File.open(song_path)
      song_yaml = YAML.load(song_file)
      song = Song.new(
        name: song_yaml["Title"],
        artist: song_yaml["Artist"],
        key: song_yaml["Suggested Key"],
        tempo: song_yaml["Tempo"],
        standard_scan: song_yaml["Standard Scan"],
        chord_sheet: song_yaml["Chord Sheet"]
      )
      if not song.valid?
        num_invalid_songs += 1
        puts song_name_from_path(song_path)
        song.errors.full_messages.each do |msg|
          puts "\t#{msg}"
        end
      elsif save_into_db
        song.save!
      end
    rescue Psych::SyntaxError => err
      puts song_name_from_path(song_path)
      puts "\tCould not parse as yaml: #{err}"
    end
  end
  puts "Done #{save_into_db ? "saving" : "validating"} songs. There were #{num_invalid_songs} invalid songs."
end

namespace :songsheets do

  desc 'Validate the format of all the yaml song sheets in a directory.'
  task :validate, [:directory_path] => :environment do |t, args|
    serialize_song_sheets(args.directory_path, save_into_db=false)
  end

  desc 'Load all the yaml song sheets in a directory into the database.'
  task :save_into_db, [:directory_path] => :environment do |t, args|
    serialize_song_sheets(args.directory_path, save_into_db=true)
  end
end