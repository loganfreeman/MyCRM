class AddLatLonAirport < ActiveRecord::Migration
  def change
    unless column_exists? :airports, :country
      add_column :airports, :country, :string
    end
    unless column_exists? :airports, :altitude
      add_column :airports, :altitude, :float
    end
    unless column_exists? :airports, :timezone
      add_column :airports, :timezone, :integer
    end
    unless column_exists? :airports, :dst
      add_column :airports, :dst, :string
    end
  end

end
