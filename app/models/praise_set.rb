class PraiseSet < ActiveRecord::Base
  has_many :praise_set_songs
  has_many :songs, :through => :praise_set_songs

  belongs_to :owner, :foreign_key => "owner", :primary_key => "email", :class_name => "User"

  validates :name, presence: true
  validates :owner, presence: true
  validates :date, presence: true
end
