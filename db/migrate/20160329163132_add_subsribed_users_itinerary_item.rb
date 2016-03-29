class AddSubsribedUsersItineraryItem < ActiveRecord::Migration
  def change
    %w(itinerary_items).each do |table|
      unless column_exists? table.to_sym, :subscribed_users
        add_column table.to_sym, :subscribed_users, :text
        # Reset the column information of each model
        table.singularize.camelize.constantize.reset_column_information
      end
    end

    entity_subscribers = Hash.new(Set.new)

    # Add comment's user to the entity's Set
    Comment.all.each do |comment|
      entity_subscribers[[comment.commentable_type, comment.commentable_id]] += [comment.user_id]
    end

    # Run as one atomic action.
    ActiveRecord::Base.transaction do
      entity_subscribers.each do |entity, user_ids|
        connection.execute "UPDATE #{entity[0].tableize} SET subscribed_users = '#{user_ids.to_a.to_yaml}' WHERE id = #{entity[1]}"
      end
    end
  end
end
