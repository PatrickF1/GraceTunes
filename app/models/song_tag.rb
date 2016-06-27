class SongTag < ActiveRecord::Base
  belongs_to :song
  belongs_to :tag
end
