class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, id: false do |t|
      # email is supposed to be the primary key but a Rails limitation prevents it from working fully
      t.string "email", null: false, unique: true
      t.timestamps null: false
      t.string "name", null: false
      t.string "role", null: false
    end
  end
end
