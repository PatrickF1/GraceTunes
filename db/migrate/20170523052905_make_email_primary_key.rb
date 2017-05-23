class MakeEmailPrimaryKey < ActiveRecord::Migration[5.1]
  def change
    execute %Q{ ALTER TABLE "users" ADD PRIMARY KEY ("email"); }
  end
end
