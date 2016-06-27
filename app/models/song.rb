class Song < ActiveRecord::Base
  has_many :tags, through: :song_tags
  
  VALID_KEY_NAMES = %w(Ab A Bb B C C# D Eb E F F# G G#)
  validates_inclusion_of :key, in: VALID_KEY_NAMES, allow_nil: true
  before_save :normalize

  private
  def normalize
    self.name = self.name.titleize
    self.artist = self.name.titleize
  end
end
