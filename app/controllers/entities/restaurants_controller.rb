# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
class RestaurantsController < EntitiesController

  # GET /Restaurants
  #----------------------------------------------------------------------------
  def index
    @restaurants = get_restaurants(page: params[:page], per_page: params[:per_page])

    respond_with @restaurants do |format|
      format.xls { render layout: 'header' }
      format.csv { render csv: @restaurants }
    end
  end

  # GET /Restaurants/1
  # AJAX /Restaurants/1
  # XLS /Restaurants/1
  # XLS /Restaurants/1
  # CSV /Restaurants/1
  # RSS /Restaurants/1
  # ATOM /Restaurants/1
  #----------------------------------------------------------------------------
  def show
    respond_with(@restaurant) do |format|
      format.html do
        @comment = Comment.new
        @timeline = timeline(@restaurant)
      end

      format.js do
        @comment = Comment.new
        @timeline = timeline(@restaurant)
      end

      format.xls do
      end

      format.csv do
        render csv: @restaurant
      end

      format.rss do
      end

      format.atom do
      end
    end
  end

  # GET /Restaurants/new
  # GET /Restaurants/new.json
  # GET /Restaurants/new.xml                                                 AJAX
  #----------------------------------------------------------------------------
  def new
    @restaurant.attributes = { user: current_user, access: Setting.default_access, assigned_to: nil }

    if params[:related]
      model, id = params[:related].split('_')
      if related = model.classify.constantize.my.find_by_id(id)
        instance_variable_set("@#{model}", related)
      else
        respond_to_related_not_found(model) && return
      end
    end

    respond_with(@restaurant)
  end

  # GET /Restaurants/1/edit                                                  AJAX
  #----------------------------------------------------------------------------
  def edit
    if params[:previous].to_s =~ /(\d+)\z/
      @previous = Restaurant.my.find_by_id(Regexp.last_match[1]) || Regexp.last_match[1].to_i
    end

    respond_with(@restaurant)
  end

  # POST /Restaurants
  #----------------------------------------------------------------------------
  def create
    @comment_body = params[:comment_body]

    respond_with(@restaurant) do |_format|
      if @restaurant.save
        @restaurant.add_comment_by_user(@comment_body, current_user)
        @restaurants = get_restaurants
      end
    end
  end

  # PUT /Restaurants/1
  #----------------------------------------------------------------------------
  def update
    respond_with(@restaurant) do |_format|
      # Must set access before user_ids, because user_ids= method depends on access value.
      @restaurant.access = resource_params[:access] if resource_params[:access]
    end
  end

  # DELETE /Restaurants/1
  #----------------------------------------------------------------------------
  def destroy
    @restaurant.destroy

    respond_with(@restaurant) do |format|
      format.html { respond_to_destroy(:html) }
      format.js   { respond_to_destroy(:ajax) }
    end
  end

  # PUT /Restaurants/1/attach
  #----------------------------------------------------------------------------
  # Handled by EntitiesController :attach

  # PUT /Restaurants/1/discard
  #----------------------------------------------------------------------------
  # Handled by EntitiesController :discard

  # POST /Restaurants/auto_complete/query                                    AJAX
  #----------------------------------------------------------------------------
  # Handled by ApplicationController :auto_complete

  # GET /Restaurants/redraw                                                  AJAX
  #----------------------------------------------------------------------------
  def redraw
    current_user.pref[:restaurants_per_page] = params[:per_page] if params[:per_page]
    current_user.pref[:restaurants_sort_by]  = Restaurant.sort_by_map[params[:sort_by]] if params[:sort_by]
    @restaurants = get_restaurants(page: 1, per_page: params[:per_page])
    set_options # Refresh options

    respond_with(@restaurants) do |format|
      format.js { render :index }
    end
  end

  # POST /Restaurants/filter                                                 AJAX
  #----------------------------------------------------------------------------
  def filter
    session[:restaurants_filter] = params[:status]
    @restaurants = get_restaurants(page: 1, per_page: params[:per_page])

    respond_with(@restaurants) do |format|
      format.js { render :index }
    end
  end

  private

  #----------------------------------------------------------------------------
  alias_method :get_restaurants, :get_list_of_records

  #----------------------------------------------------------------------------
  def respond_to_destroy(method)
    if method == :ajax
      @restaurants = get_restaurants
      if @restaurants.blank?
        @restaurants = get_restaurants(page: current_page - 1) if current_page > 1
        render(:index) && return
      end
      # At this point render destroy.js
    else # :html request
      self.current_page = 1
      flash[:notice] = t(:msg_asset_deleted, @restaurant.name)
      redirect_to restaurants_path
    end
  end

end
