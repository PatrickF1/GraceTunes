# frozen_string_literal: true

class User < ApplicationRecord
  self.primary_key = :email

  has_many :praise_sets, foreign_key: "owner_email", primary_key: "email"

  before_validation :normalize

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :role, presence: true, inclusion: { in: Role::VALID_ROLES, if: ->(user) { user.role.present? } }

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
