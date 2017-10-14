class PraiseSet < ActiveRecord::Base
  has_many :praise_set_songs, -> { order(position: :asc) }
  has_many :songs, :through => :praise_set_songs

  belongs_to :owner, :foreign_key => "owner_email", :primary_key => "email", :class_name => "User"

  validates :event_name, presence: true
  validates :event_date, presence: true
  validates :owner_email, presence: true
  validates_inclusion_of :archived, in: [true, false]

  def add_song(song)
    # need to manually construct PraiseSetSong in order to set key before acts_as_list tries to save PraiseSetSong to db
    # position will still be taken care of
    new_praise_set_song = PraiseSetSong.new
    new_praise_set_song.praise_set_id = id
    new_praise_set_song.song_id = song.id
    new_praise_set_song.key = song.key
    praise_set_songs << new_praise_set_song
  end
end
