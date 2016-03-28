class AddRatingRestaurant < ActiveRecord::Migration
  def change
    unless column_exists? :hotels, :rating
      add_column :hotels, :rating, :string
    end
  end
end
