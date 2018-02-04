class PraiseSetSong < ActiveRecord::Base
  belongs_to :praise_set
  belongs_to :song

  acts_as_list scope: :praise_set, top_of_list: 0

  validates :key, presence: true
end
