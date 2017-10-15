# Turns off record_timestamps temporarily so that the updated_at field
# will not be touched. Preserves current order of songs.
def defragment_ids
  begin
    ActiveRecord::Base.record_timestamps = false
    current_id = 1
    # find_each retrives songs in order of "id ASC"
    Song.find_each do |song|
      song.id = current_id
      song.save!
      current_id += 1
    end
  ensure
    ActiveRecord::Base.record_timestamps = true
  end
end

namespace :songs do
  desc 'Defragment song ids so that the lowest id starts at 1 and there are no gaps.'
  task :defrag_ids  => :environment do |t, args|
    defragment_ids()
  end
end