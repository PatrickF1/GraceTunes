# Add GraceTunes team to users table with admin privileges so they can access all parts of the app
User.create(
  email: "patrick.fong@gpmail.org",
  name: "Patrick Fong",
  role: Role::ADMIN
)
User.create(
  email: "nathan.connor@gpmail.org",
  name: "Nathan Connor",
  role: Role::ADMIN
)
User.create(
  email: "winstons.kim@gpmail.org",
  name: "Winston Kim",
  role: Role::ADMIN
)
User.create(
  email: "steven.chang2@gpmail.org",
  name: "Steven Chang",
  role: Role::ADMIN
)
User.create(
  email: "ivan.yung@gpmail.org",
  name: "Ivan Yung",
  role: Role::ADMIN
)
User.create(
  email: "andrew.martinez@gpmail.org",
  name: "Andrew Martinez",
  role: Role::ADMIN
)