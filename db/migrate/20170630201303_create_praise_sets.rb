class CreatePraiseSets < ActiveRecord::Migration[5.1]
  def change
    create_table :praise_sets do |t|
      t.timestamps null: false
      t.string :owner, null: false
      t.string :event_name, null: false
      t.date :event_date, null: false
      t.text :notes
    end

    add_index :praise_sets, :owner
    add_index :praise_sets, :event_name
    add_index :praise_sets, :event_date
  end
end
