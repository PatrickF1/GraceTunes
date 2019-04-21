class AddTimesViewedToSongs < ActiveRecord::Migration[5.1]

  def up
    add_column(:songs, :times_viewed, :integer, default: 0, null: false)
    execute <<-SQL
        ALTER TABLE songs ADD CONSTRAINT times_viewed_is_gte_zero CHECK (times_viewed >= 0);
      SQL
  end

  def down
    remove_column(:songs, :times_viewed)
  end
end
