class SuppliersController < ApplicationController
  def index
    @my_hotels = Hotel.visible_on_dashboard(current_user).includes(:user, :tags).by_name
    @my_restaurants = Restaurant.visible_on_dashboard(current_user).includes(:user, :tags).by_name
    @my_parks = Park.visible_on_dashboard(current_user).includes(:user, :tags).by_name
  end
end
