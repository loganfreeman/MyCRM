# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
class MealsController < EntitiesController
  before_action :get_meals, only: [:new, :create, :edit, :update]

  # GET /Meals
  #----------------------------------------------------------------------------
  def index
    @meals = get_meals(page: params[:page], per_page: params[:per_page])

    respond_with @meals do |format|
      format.xls { render layout: 'header' }
      format.csv { render csv: @meals }
    end
  end

  # GET /Meals/1
  # AJAX /Meals/1
  # XLS /Meals/1
  # XLS /Meals/1
  # CSV /Meals/1
  # RSS /Meals/1
  # ATOM /Meals/1
  #----------------------------------------------------------------------------
  def show
    respond_with(@meal) do |format|
      format.html do
      end

      format.js do
      end

      format.xls do
      end

      format.csv do
        render csv: @meal
      end

      format.rss do
      end

      format.atom do
      end
    end
  end

  # GET /Meals/new
  # GET /Meals/new.json
  # GET /Meals/new.xml                                                 AJAX
  #----------------------------------------------------------------------------
  def new
    if params[:related]
      model, id = params[:related].split('_')
      if related = model.classify.constantize.my.find_by_id(id)
        instance_variable_set("@#{model}", related)
      else
        respond_to_related_not_found(model) && return
      end
    end

    respond_with(@meal)
  end

  # GET /Meals/1/edit                                                  AJAX
  #----------------------------------------------------------------------------
  def edit
    if params[:previous].to_s =~ /(\d+)\z/
      @previous = Meal.my.find_by_id(Regexp.last_match[1]) || Regexp.last_match[1].to_i
    end

    respond_with(@meal)
  end

  # POST /Meals
  #----------------------------------------------------------------------------
  def create
    @comment_body = params[:comment_body]

    respond_with(@meal) do |_format|
      if @meal.save
        @meals = get_meals
      end
    end
  end

  # PUT /Meals/1
  #----------------------------------------------------------------------------
  def update
    respond_with(@meal) do |_format|
      @meal.update_attributes(params.require(:meal).permit!)
      @meal.save
    end
  end

  # DELETE /Meals/1
  #----------------------------------------------------------------------------
  def destroy
    @meal.destroy

    respond_with(@meal) do |format|
      format.html { respond_to_destroy(:html) }
      format.js   { respond_to_destroy(:ajax) }
    end
  end

  # PUT /Meals/1/attach
  #----------------------------------------------------------------------------
  # Handled by EntitiesController :attach

  # PUT /Meals/1/discard
  #----------------------------------------------------------------------------
  # Handled by EntitiesController :discard

  # POST /Meals/auto_complete/query                                    AJAX
  #----------------------------------------------------------------------------
  # Handled by ApplicationController :auto_complete

  # GET /Meals/redraw                                                  AJAX
  #----------------------------------------------------------------------------
  def redraw
    current_user.pref[:meals_per_page] = params[:per_page] if params[:per_page]
    current_user.pref[:meals_sort_by]  = Meal.sort_by_map[params[:sort_by]] if params[:sort_by]
    @meals = get_meals(page: 1, per_page: params[:per_page])
    set_options # Refresh options

    respond_with(@meals) do |format|
      format.js { render :index }
    end
  end

  # POST /Meals/filter                                                 AJAX
  #----------------------------------------------------------------------------
  def filter
    session[:meals_filter] = params[:status]
    @meals = get_meals(page: 1, per_page: params[:per_page])

    respond_with(@meals) do |format|
      format.js { render :index }
    end
  end

  private

  #----------------------------------------------------------------------------
  alias_method :get_meals, :get_list_of_records

  #----------------------------------------------------------------------------
  def respond_to_destroy(method)
    if method == :ajax
      @meals = get_meals
      if @meals.blank?
        @meals = get_meals(page: current_page - 1) if current_page > 1
        render(:index) && return
      end
      # At this point render destroy.js
    else # :html request
      self.current_page = 1
      flash[:notice] = t(:msg_asset_deleted, @meal.name)
      redirect_to meals_path
    end
  end

end
