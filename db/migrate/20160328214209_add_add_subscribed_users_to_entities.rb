class AddAddSubscribedUsersToEntities < ActiveRecord::Migration
  def change
    %w(conferences entertainments exibitions hotels itineraries parks restaurants transports).each do |table|
      unless column_exists? table.to_sym, :subscribed_users
        add_column table.to_sym, :subscribed_users, :text
        # Reset the column information of each model
        table.singularize.capitalize.constantize.reset_column_information
      end
    end
  end
end
