class CreatePraiseSets < ActiveRecord::Migration
  def change
    create_table :praise_sets do |t|
      t.string :name, null: false
      t.string :owner, null: false
      t.date :date

      t.timestamps null: false
    end

    add_index :praise_sets, :name
    add_index :praise_sets, :owner
    add_index :praise_sets, :date
  end
end
