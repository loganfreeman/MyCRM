class AddSubsribedUsersItineraryItem < ActiveRecord::Migration
  def change
    %w(itinerary_items).each do |table|
      unless column_exists? table.to_sym, :subscribed_users
        add_column table.to_sym, :subscribed_users, :text
        # Reset the column information of each model
        table.singularize.camelize.constantize.reset_column_information
      end
    end
  end
end
