class MakeKeyAndTempoNonNullable < ActiveRecord::Migration
  def change
    # removed the size 2 limit on key because it doesn't
    # yield a speed advantage in Postgres as it did on MySql
    change_column :songs, :key, :string, null: false
    change_column :songs, :tempo, :string, null: false
  end
end
