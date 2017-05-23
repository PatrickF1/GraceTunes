class MakeEmailPrimaryKey < ActiveRecord::Migration[5.1]
  def up
    execute "ALTER TABLE users ADD PRIMARY KEY (email)"
  end

  def down
    execute "ALTER TABLE USERS DROP CONSTRAINT users_pkey"
  end
end
