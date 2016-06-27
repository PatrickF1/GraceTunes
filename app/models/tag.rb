class Tag < ActiveRecord::Base

  has_many :songs, through: :song_tags
  before_save :normalize

  private
  def normalize
    self.name = self.name.titleize
    self.artist = self.name.titleize
  end

end
