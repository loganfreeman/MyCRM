# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
class HotelsController < EntitiesController
  before_action :get_hotels, only: [:new, :create, :edit, :update]

  # GET /Hotels
  #----------------------------------------------------------------------------
  def index
    @hotels = get_hotels(page: params[:page], per_page: params[:per_page])

    respond_with @hotels do |format|
      format.xls { render layout: 'header' }
      format.csv { render csv: @hotels }
    end
  end

  # GET /Hotels/1
  # AJAX /Hotels/1
  # XLS /Hotels/1
  # XLS /Hotels/1
  # CSV /Hotels/1
  # RSS /Hotels/1
  # ATOM /Hotels/1
  #----------------------------------------------------------------------------
  def show
    respond_with(@hotel) do |format|
      format.html do
        @comment = Comment.new
        @timeline = timeline(@hotel)
      end

      format.js do
        @comment = Comment.new
        @timeline = timeline(@hotel)
      end

      format.xls do
      end

      format.csv do
        render csv: @hotel
      end

      format.rss do
      end

      format.atom do
      end
    end
  end

  # GET /Hotels/new
  # GET /Hotels/new.json
  # GET /Hotels/new.xml                                                 AJAX
  #----------------------------------------------------------------------------
  def new
    @hotel.attributes = { user: current_user, access: Setting.default_access, assigned_to: nil }

    if params[:related]
      model, id = params[:related].split('_')
      if related = model.classify.constantize.my.find_by_id(id)
        instance_variable_set("@#{model}", related)
      else
        respond_to_related_not_found(model) && return
      end
    end

    respond_with(@hotel)
  end

  # GET /Hotels/1/edit                                                  AJAX
  #----------------------------------------------------------------------------
  def edit
    if params[:previous].to_s =~ /(\d+)\z/
      @previous = Hotel.my.find_by_id(Regexp.last_match[1]) || Regexp.last_match[1].to_i
    end

    respond_with(@hotel)
  end

  # POST /Hotels
  #----------------------------------------------------------------------------
  def create
    @comment_body = params[:comment_body]

    respond_with(@hotel) do |_format|
      if @hotel.save
        @hotel.add_comment_by_user(@comment_body, current_user)
        @hotels = get_hotels
      end
    end
  end

  # PUT /Hotels/1
  #----------------------------------------------------------------------------
  def update
    respond_with(@hotel) do |_format|
      # Must set access before user_ids, because user_ids= method depends on access value.
      @hotel.access = resource_params[:access] if resource_params[:access]
    end
  end

  # DELETE /Hotels/1
  #----------------------------------------------------------------------------
  def destroy
    @hotel.destroy

    respond_with(@hotel) do |format|
      format.html { respond_to_destroy(:html) }
      format.js   { respond_to_destroy(:ajax) }
    end
  end

  # PUT /Hotels/1/attach
  #----------------------------------------------------------------------------
  # Handled by EntitiesController :attach

  # PUT /Hotels/1/discard
  #----------------------------------------------------------------------------
  # Handled by EntitiesController :discard

  # POST /Hotels/auto_complete/query                                    AJAX
  #----------------------------------------------------------------------------
  # Handled by ApplicationController :auto_complete

  # GET /Hotels/redraw                                                  AJAX
  #----------------------------------------------------------------------------
  def redraw
    current_user.pref[:hotels_per_page] = params[:per_page] if params[:per_page]
    current_user.pref[:hotels_sort_by]  = Conference.sort_by_map[params[:sort_by]] if params[:sort_by]
    @hotels = get_hotels(page: 1, per_page: params[:per_page])
    set_options # Refresh options

    respond_with(@hotels) do |format|
      format.js { render :index }
    end
  end

  # POST /Hotels/filter                                                 AJAX
  #----------------------------------------------------------------------------
  def filter
    session[:hotels_filter] = params[:status]
    @hotels = get_hotels(page: 1, per_page: params[:per_page])

    respond_with(@hotels) do |format|
      format.js { render :index }
    end
  end

  private

  #----------------------------------------------------------------------------
  alias_method :get_hotels, :get_list_of_records

  #----------------------------------------------------------------------------
  def respond_to_destroy(method)
    if method == :ajax
      @hotels = get_hotels
      if @hotels.blank?
        @hotels = get_hotels(page: current_page - 1) if current_page > 1
        render(:index) && return
      end
      # At this point render destroy.js
    else # :html request
      self.current_page = 1
      flash[:notice] = t(:msg_asset_deleted, @hotel.name)
      redirect_to hotels_path
    end
  end

end
