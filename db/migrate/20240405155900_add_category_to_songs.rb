class AddCategoryToSongs < ActiveRecord::Migration[7.1]
  def change
    add_column :songs, :category, :string
  end
end
