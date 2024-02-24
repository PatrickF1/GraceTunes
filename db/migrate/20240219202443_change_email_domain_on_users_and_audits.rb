# frozen_string_literal: true

class ChangeEmailDomainOnUsersAndAudits < ActiveRecord::Migration[7.1]
  def up
    execute("UPDATE users SET email = replace(email, '@gpmail.org',  '@acts2.network')")
    execute("UPDATE audits SET user_id = replace(user_id, '@gpmail.org',  '@acts2.network')")
  end

  def down
    execute("UPDATE users SET email = replace(email,  '@acts2.network', '@gpmail.org')")
    execute("UPDATE audits SET user_id = replace(user_id, '@acts2.network', '@gpmail.org')")
  end
end
