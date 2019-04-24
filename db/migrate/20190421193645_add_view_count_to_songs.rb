class AddViewCountToSongs < ActiveRecord::Migration[5.1]

  def up
    add_column(:songs, :view_count, :integer, default: 0, null: false)
    execute <<-SQL
        ALTER TABLE songs ADD CONSTRAINT view_count_gte_zero CHECK (view_count >= 0);
      SQL
  end

  def down
    remove_column(:songs, :view_count)
  end
end
