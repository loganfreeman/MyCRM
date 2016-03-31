# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
class GuideDriversController < EntitiesController
  before_action :get_guide_drivers, only: [:new, :create, :edit, :update]

  # GET /GuideDrivers
  #----------------------------------------------------------------------------
  def index
    @guide_drivers = get_guide_drivers(page: params[:page], per_page: params[:per_page])

    respond_with @guide_drivers do |format|
      format.xls { render layout: 'header' }
      format.csv { render csv: @guide_drivers }
    end
  end

  # GET /GuideDrivers/1
  # AJAX /GuideDrivers/1
  # XLS /GuideDrivers/1
  # XLS /GuideDrivers/1
  # CSV /GuideDrivers/1
  # RSS /GuideDrivers/1
  # ATOM /GuideDrivers/1
  #----------------------------------------------------------------------------
  def show
    respond_with(@guide_driver) do |format|
      format.html do
      end

      format.js do
      end

      format.xls do
      end

      format.csv do
        render csv: @guide_driver
      end

      format.rss do
      end

      format.atom do
      end
    end
  end

  # GET /GuideDrivers/new
  # GET /GuideDrivers/new.json
  # GET /GuideDrivers/new.xml                                                 AJAX
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

    respond_with(@guide_driver)
  end

  # GET /GuideDrivers/1/edit                                                  AJAX
  #----------------------------------------------------------------------------
  def edit
    if params[:previous].to_s =~ /(\d+)\z/
      @previous = GuideDriver.my.find_by_id(Regexp.last_match[1]) || Regexp.last_match[1].to_i
    end

    respond_with(@guide_driver)
  end

  # POST /GuideDrivers
  #----------------------------------------------------------------------------
  def create
    @comment_body = params[:comment_body]

    respond_with(@guide_driver) do |_format|
      if @guide_driver.save
        @guide_drivers = get_guide_drivers
      end
    end
  end

  # PUT /GuideDrivers/1
  #----------------------------------------------------------------------------
  def update
    respond_with(@guide_driver) do |_format|
      @guide_driver.update_attributes(params.require(:guide_driver).permit!)
      @guide_driver.save
    end
  end

  # DELETE /GuideDrivers/1
  #----------------------------------------------------------------------------
  def destroy
    @guide_driver.destroy

    respond_with(@guide_driver) do |format|
      format.html { respond_to_destroy(:html) }
      format.js   { respond_to_destroy(:ajax) }
    end
  end

  # PUT /GuideDrivers/1/attach
  #----------------------------------------------------------------------------
  # Handled by EntitiesController :attach

  # PUT /GuideDrivers/1/discard
  #----------------------------------------------------------------------------
  # Handled by EntitiesController :discard

  # POST /GuideDrivers/auto_complete/query                                    AJAX
  #----------------------------------------------------------------------------
  # Handled by ApplicationController :auto_complete

  # GET /GuideDrivers/redraw                                                  AJAX
  #----------------------------------------------------------------------------
  def redraw
    current_user.pref[:guide_drivers_per_page] = params[:per_page] if params[:per_page]
    current_user.pref[:guide_drivers_sort_by]  = GuideDriver.sort_by_map[params[:sort_by]] if params[:sort_by]
    @guide_drivers = get_guide_drivers(page: 1, per_page: params[:per_page])
    set_options # Refresh options

    respond_with(@guide_drivers) do |format|
      format.js { render :index }
    end
  end

  # POST /GuideDrivers/filter                                                 AJAX
  #----------------------------------------------------------------------------
  def filter
    session[:guide_drivers_filter] = params[:status]
    @guide_drivers = get_guide_drivers(page: 1, per_page: params[:per_page])

    respond_with(@guide_drivers) do |format|
      format.js { render :index }
    end
  end

  private

  #----------------------------------------------------------------------------
  alias_method :get_guide_drivers, :get_list_of_records

  #----------------------------------------------------------------------------
  def respond_to_destroy(method)
    if method == :ajax
      @guide_drivers = get_guide_drivers
      if @guide_drivers.blank?
        @guide_drivers = get_guide_drivers(page: current_page - 1) if current_page > 1
        render(:index) && return
      end
      # At this point render destroy.js
    else # :html request
      self.current_page = 1
      flash[:notice] = t(:msg_asset_deleted, @guide_driver.name)
      redirect_to guide_drivers_path
    end
  end

end
