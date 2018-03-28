class PraiseSet < ActiveRecord::Base

  validates :event_name, presence: true
  validates :event_date, presence: true
  validates :owner_email, presence: true
  validates_inclusion_of :archived, in: [true, false]

end