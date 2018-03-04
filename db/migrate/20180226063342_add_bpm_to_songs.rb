class AddBPMToSongs < ActiveRecord::Migration[5.1]
  def up
    add_column :songs, :bpm, :integer
    execute <<-SQL
              ALTER TABLE
                songs
              ADD CONSTRAINT
                is_valid_bpm
              CHECK (
                bpm BETWEEN 1 AND 1000
              );
            SQL
  end

  def down
    remove_column(:songs, :bpm)
  end
end
