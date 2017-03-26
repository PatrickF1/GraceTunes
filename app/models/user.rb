class User < ActiveRecord::Bases

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
    role == ROLES[1] || role == ROLES[2]
  end

  def can_delete?
    role == ROLES[2]
  end

  def to_s
    "#{name} <#{email}>"
  end

end
