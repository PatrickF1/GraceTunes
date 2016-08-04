class InstallPostgresContribPackages < ActiveRecord::Migration
  
  def up
    execute "CREATE EXTENSION IF NOT EXISTS plpgsql;"
    execute "CREATE EXTENSION IF NOT EXISTS btree_gin;"
  end

  def down
    execute "DROP EXTENSION IF EXISTS plpgsql;"
    execute "DROP EXTENSION IF EXISTS btree_gin;"
  end

end
