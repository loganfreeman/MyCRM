# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
namespace :ffcrm do
  namespace :settings do
    desc "Clear settings from database (reset to default)"
    task clear: :environment do
      Setting.delete_all
    end

    desc "Show current settings in the database"
    task show: :environment do
      Setting.select('name').order('name').pluck('name').each do |name|
        puts "\n#{name}:\n  #{Setting.send(name).inspect}"
      end
    end
  end

  namespace :airports do
    desc "reformat airport codes"
    task reformat: :environment do
      require "csv"
      require "json"

      airport_data = {}

      CSV.foreach(Rails.root.join('lib', "airports.dat")) do |row|
        airport_data[row[4]] = {
          :name => row[1],
          :city => row[2],
          :country => row[3],
          :iata => row[4],
          :icao => row[5],
          :latitude => row[6],
          :longitude => row[7],
          :altitude => row[8],
          :timezone => row[9],
          :dst => row[10]
        }
      end

      File.open(Rails.root.join('lib', "airports.json"), "w").puts JSON.generate(airport_data)
    end
  end
end
