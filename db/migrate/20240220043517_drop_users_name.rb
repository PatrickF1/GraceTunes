class DropUsersName < ActiveRecord::Migration[7.1]
  def change
    remove_column(:users, :name)
  end
end
