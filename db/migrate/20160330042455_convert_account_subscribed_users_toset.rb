class ConvertAccountSubscribedUsersToset < ActiveRecord::Migration
  def change
    # Change the other tables that were missing from the previous migration
    %w(campaigns opportunities leads tasks accounts contacts itinerary_items conferences entertainments exibitions hotels itineraries parks restaurants transports).each do |table|
      entities = connection.select_all %(
        SELECT id, subscribed_users
        FROM #{table}
        WHERE subscribed_users IS NOT NULL
            )

      puts "#{table}: Converting #{entities.length} subscribed_users arrays into sets..." unless entities.empty?

      # Run as one atomic action.
      ActiveRecord::Base.transaction do
        entities.each do |entity|
          subscribed_users_set = Set.new(YAML.load(entity["subscribed_users"]))

          connection.execute %(
            UPDATE #{table}
            SET subscribed_users = '#{subscribed_users_set.to_yaml}'
            WHERE id = #{entity['id']}
                    )
        end
      end
    end
  end
end
