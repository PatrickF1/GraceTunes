class Tag < ActiveRecord::Base

  has_many :songs, through: :song_tags
  before_save :normalize

  validates :name, presence: true
  
  private
  def normalize
    self.name = self.name.titleize
  end

end
