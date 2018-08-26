class PraiseSet < ApplicationRecord

  belongs_to :owner, :foreign_key => "owner_email", :primary_key => "email", :class_name => "User"

  validates :event_name, presence: true
  validates :event_date, presence: true
  validates :owner, presence: true

  validates_inclusion_of :archived, in: [true, false]

end