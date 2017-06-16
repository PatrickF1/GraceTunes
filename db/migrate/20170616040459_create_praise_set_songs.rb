class CreatePraiseSetSongs < ActiveRecord::Migration[5.1]
  def change
    create_table :praise_set_songs do |t|
      t.references :praise_set
      t.references :song
    end
  end
end
