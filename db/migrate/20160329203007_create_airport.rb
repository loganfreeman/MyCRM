class CreateAirport < ActiveRecord::Migration
  def self.up
    create_table :airports do |t|
      # "id","ident","type","name","latitude_deg","longitude_deg","elevation_ft",
      # "continent","iso_country","iso_region","municipality","scheduled_service","gps_code","iata_code","local_code","home_link","wikipedia_link","keywords"
      t.string :ident
      t.string :name
      t.string :city
      t.string :size
      t.string :keywords
      t.boolean :scheduled_service

      t.float :lat
      t.float :lon
      t.string :iata_code
      t.string :local_code
    end

    add_index :airports, :scheduled_service
    add_index :airports, :ident
  end
  def self.down
    drop_table :airports
  end
end
