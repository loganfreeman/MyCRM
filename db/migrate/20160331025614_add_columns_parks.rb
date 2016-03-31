class AddColumnsParks < ActiveRecord::Migration
  def change
    unless column_exists? :parks, :city
      add_column :parks, :city, :string
    end
    unless column_exists? :parks, :state
      add_column :parks, :state, :string
    end
    unless column_exists? :parks, :country
      add_column :parks, :country, :string
    end
  end
end
