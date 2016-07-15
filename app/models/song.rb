class Song < ActiveRecord::Base
  has_many :tags, through: :song_tags
  
  VALID_KEYS = %w(Ab A Bb B C C# D Eb E F F# G G#)
  VALID_TEMPOS = %w(Fast Medium Slow)

  validates :name, presence: true
  validates :song_sheet, presence: true
  validates_inclusion_of :key, in: VALID_KEYS, allow_nil: true
  validates_inclusion_of :tempo, in: VALID_TEMPOS, allow_nil: true
  before_save :normalize

  private
  def normalize
    self.name = self.name.titleize
    self.artist = self.artist.titleize if self.artist
  end
  
  def self.search(query)
    if query
      where('name LIKE ? OR song_sheet LIKE?', "%#{query}%", "%#{query}%")
    end
  end
end
