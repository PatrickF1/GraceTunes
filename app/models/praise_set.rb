class PraiseSet < ApplicationRecord

  belongs_to :owner, :foreign_key => "owner_email", :primary_key => "email", :class_name => "User"

  validates :event_name, presence: true
  validates :event_date, presence: true
  validates :owner, presence: true
  validates_inclusion_of :archived, in: [true, false]
  validates :song_references

  before_validate :enforce_structure
  private
  def song_references
    praise_set_songs.each do |pss|
      if not Song.exists?(id: pss.id)

      end
    end
  end

end