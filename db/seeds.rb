# Add GraceTunes devs to users table with admin privileges so they can access the app
User.create(
  email: "patrick.fong@gpmail.org"
  name: "Patrick Fong",
  role: Role::ADMIN
)
User.create(
  email: "nathan.connor@gpmail.org"
  name: "Nathan Connor",
  role: Role::ADMIN
)
User.create(
  email: "winstons.kim@gpmail.org"
  name: "Winston Kim",
  role: Role::ADMIN
)