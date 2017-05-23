class MakePraiseSetDateNonNullable < ActiveRecord::Migration[5.1]
  def change
    change_column :praise_sets, :date, :date, null: false
  end
end
