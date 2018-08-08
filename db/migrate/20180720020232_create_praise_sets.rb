class CreatePraiseSets < ActiveRecord::Migration[5.1]
  def change
    create_table :praise_sets do |t|
      t.timestamps null: false
      t.string :owner_email, null: false
      t.string :event_name, null: false
      t.date :event_date, null: false
      t.text :notes
      t.boolean :archived, null: false
      t.jsonb :praise_set_songs, default: []
    end

    add_index :praise_sets, :owner_email
  end
end
