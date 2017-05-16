class CreatePraiseSets < ActiveRecord::Migration
  def change
    create_table :praise_sets do |t|
      t.string :name, null: false

      t.timestamps null: false
    end

    add_index :praise_sets, :name
  end
end
