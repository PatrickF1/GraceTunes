class User < ActiveRecord::Base

  # No difference between Praise and Admin roles for now
  # I created an extra one for future-proofing
  ROLES = %w(Reader Praise Admin)

  before_validation :normalize

  validates :name, presence: true
  validates :email, presence: true
  validates :role, presence: true
  validates_inclusion_of :role, in: ROLES, if: -> (user) { user.role.present? }

  def normalize
    self.name = name.titleize.strip if name
    self.email = email.strip if email
    self.role = role.titleize if role
  end

  def can_edit?
    role.in? %w(Praise Admin)
  end

  def can_delete?
    role == "Admin"
  end

  def to_s
    "#{name} <#{email}>"
  end

end
