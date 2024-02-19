# frozen_string_literal: true

# Add GraceTunes team to users table with admin privileges so they can access all parts of the app
User.create!(
  email: "patrick.fong@acts2.network",
  name: "Patrick Fong",
  role: Role::ADMIN
)
User.create!(
  email: "nathan.connor@acts2.network",
  name: "Nathan Connor",
  role: Role::ADMIN
)
User.create!(
  email: "winston.kim@acts2.network",
  name: "Winston Kim",
  role: Role::ADMIN
)
User.create!(
  email: "steven.chang2@acts2.network",
  name: "Steven Chang",
  role: Role::ADMIN
)
User.create!(
  email: "ivan.yung@acts2.network",
  name: "Ivan Yung",
  role: Role::ADMIN
)
User.create!(
  email: "andrew.martinez@acts2.network",
  name: "Andrew Martinez",
  role: Role::ADMIN
)
