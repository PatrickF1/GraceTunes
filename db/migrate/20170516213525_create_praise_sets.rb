class CreatePraiseSets < ActiveRecord::Migration[5.1]
  def change
    create_table :praise_sets do |t|
      t.timestamps null: false
      t.string :name, null: false
      t.string :owner, null: false
      t.date :date

    end

    add_index :praise_sets, :name
    add_index :praise_sets, :owner
    add_index :praise_sets, :date
  end
end
