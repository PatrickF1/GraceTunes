class PraiseSetSong
  include ActiveModel::Model

  attr_accessor :song_id, :song_key

  validates :song_id, presence: true
  validates :song_key, presence: true
  validates_inclusion_of :song_key, in: Music::MAJOR_KEYS, if: -> (song) { song.key.present? }

end