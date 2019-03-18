def song_name_from_path(song_path)
  "#{File.basename(song_path, '.yaml')}"
end

def create_file_with_song(song)
  Pdfgenerator.generate_pdf(song)
end

# serialize songs from .yaml files at directory_path and save into database if flag is set
def serialize_song_sheets(directory_path, save_into_db=false)
  # make sure directory_path is a valid directory
  abort("Must specify directory_path.") if directory_path.nil?
  abort("\"#{directory_path}\" does not exist or is not a directory.") unless File.directory?(directory_path)
  directory_path = directory_path.chomp("/")

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

namespace :song_sheets do

  desc 'Validate the format of all the yaml song sheets in a directory.'
  task :validate, [:directory_path] => :environment do |t, args|
    serialize_song_sheets(args.directory_path, false)
  end

  desc 'Load all the yaml song sheets in a directory into the database.'
  task :save_into_db, [:directory_path] => :environment do |t, args|
    serialize_song_sheets(args.directory_path, true)
  end

  desc 'Generate song sheets for all songs in the database.'
  task :generate_song_sheets => :environment do |t, args|
    Song.find_each do |song|
      create_file_with_song(song)
    end
  end

end
