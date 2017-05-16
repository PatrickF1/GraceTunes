class PraiseSet < ActiveRecord::Base
  has_many :praise_set_songs
  has_many :songs, :through => :praise_set_songs
end
