class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string "email", null: false
      t.timestamps null: false
      t.string "name", null: false
      t.string "role", null: false
    end
  end
end
