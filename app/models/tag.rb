class Tag < ApplicationRecord

  has_many :song_tags
  has_many :songs, through: :song_tags
  before_save :normalize

  validates :name, presence: true

  private
  def normalize
    self.name = name.titleize
  end

end
