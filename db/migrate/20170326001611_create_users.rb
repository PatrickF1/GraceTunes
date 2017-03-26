class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.string "email"
      t.timestamps null: false
      t.string "name"
      t.string "role"
    end
  end
end
