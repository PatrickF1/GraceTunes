class DeleteTags < ActiveRecord::Migration[7.1]
  def change
    drop_table(:song_tags) do |t|
      t.references :song
      t.references :tag
      t.timestamps null: false
    end

    drop_table(:tags) do |t|
      t.string :name, null: false
      t.timestamps null: false
    end
  end
end
