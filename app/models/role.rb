class Role
  # Readers can perform any read action
  READER = "Reader"
  # Praise members can create and edit songs
  PRAISE = "Praise"
  # Admins can delete songs
  ADMIN  = "Admin"

  VALID_ROLES = [READER, PRAISE, ADMIN].freeze
end