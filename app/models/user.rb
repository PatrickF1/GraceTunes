class User < ActiveRecord::Base
  self.primary_key = :email

  before_validation :normalize

  validates :name, presence: true
  validates :email, presence: true
  validates :role, presence: true
  validates_inclusion_of :role, in: Role::VALID_ROLES, if: -> (user) { user.role.present? }

  def normalize
    self.name = name.titleize.strip if name
    self.email = email.strip if email
    self.role = role.titleize if role
  end

  def can_edit?
    role.in? [Role::PRAISE, Role::ADMIN]
  end

  def can_delete?
    role == Role::ADMIN
  end

  def to_s
    "#{name} <#{email}>"
  end

end
