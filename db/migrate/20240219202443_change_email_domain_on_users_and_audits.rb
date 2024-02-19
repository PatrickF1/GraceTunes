class ChangeEmailDomainOnUsersAndAudits < ActiveRecord::Migration[7.1]
  def up
    Users.connection.execute("UPDATE users SET email = replace(email, @gpmail.org, @acts2.network)")
    Audits.connection.execute("UPDATE audits SET user_id = replace(user_id, @gpmail.org, @acts2.network)")
  end
end
