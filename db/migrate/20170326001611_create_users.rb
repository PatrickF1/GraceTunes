class CreateUsers < ActiveRecord::Migration
  def change
    # Email is supposed to be the primary key but a Rails bug prevents it from working fully
    # and it didn't get fixed until Rails 5. However, the combination of a not null and unique
    # constraint (from the app) essentially implements the primary key constraint.
    create_table "users", id: false do |t|
      t.string "email", null: false
      t.timestamps null: false
      t.string "name", null: false
      t.string "role", null: false
    end
  end
end
