class ChangeEmailDomainOnUsersAndAudits < ActiveRecord::Migration[7.1]
  def up
    User.connection.execute("UPDATE users SET email = replace(email, '@gpmail.org',  '@acts2.network')")
    Audited.audit_class.connection.execute("UPDATE audits SET user_id = replace(user_id, '@gpmail.org',  '@acts2.network')")
  end

  def down
    User.connection.execute("UPDATE users SET email = replace(email,  '@acts2.network', '@gpmail.org')")
    Audited.audit_class.connection.execute("UPDATE audits SET user_id = replace(user_id, '@acts2.network', '@gpmail.org')")
  end
end
