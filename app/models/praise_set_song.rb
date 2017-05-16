class PraiseSetSong < ActiveRecord::Base
  belongs_to :praise_set
  belongs_to :song
end
