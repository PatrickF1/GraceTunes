class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users, id: false, primary_key: "email" do |t|
      t.string "email", null: false
      t.timestamps null: false
      t.string "name", null: false
      t.string "role", null: false
    end
    execute "ALTER TABLE users ADD PRIMARY KEY (email);"
  end

  def down
    drop_table :users
  end
end
