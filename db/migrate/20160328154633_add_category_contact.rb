class AddCategoryContact < ActiveRecord::Migration
  def change
    unless column_exists? :contacts, :category
      add_column :contacts, :category, :string
    end
  end
end
