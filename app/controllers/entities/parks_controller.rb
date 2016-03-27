# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
class ParksController < EntitiesController

  # GET /Parks
  #----------------------------------------------------------------------------
  def index
    @parks = get_parks(page: params[:page], per_page: params[:per_page])

    respond_with @parks do |format|
      format.xls { render layout: 'header' }
      format.csv { render csv: @parks }
    end
  end

  # GET /Parks/1
  # AJAX /Parks/1
  # XLS /Parks/1
  # XLS /Parks/1
  # CSV /Parks/1
  # RSS /Parks/1
  # ATOM /Parks/1
  #----------------------------------------------------------------------------
  def show
    respond_with(@park) do |format|
      format.html do
        @comment = Comment.new
        @timeline = timeline(@park)
      end

      format.js do
        @comment = Comment.new
        @timeline = timeline(@park)
      end

      format.xls do
      end

      format.csv do
        render csv: @park
      end

      format.rss do
      end

      format.atom do
      end
    end
  end

  # GET /Parks/new
  # GET /Parks/new.json
  # GET /Parks/new.xml                                                 AJAX
  #----------------------------------------------------------------------------
  def new
    @park.attributes = { user: current_user, access: Setting.default_access, assigned_to: nil }

    if params[:related]
      model, id = params[:related].split('_')
      if related = model.classify.constantize.my.find_by_id(id)
        instance_variable_set("@#{model}", related)
      else
        respond_to_related_not_found(model) && return
      end
    end

    respond_with(@park)
  end

  # GET /Parks/1/edit                                                  AJAX
  #----------------------------------------------------------------------------
  def edit
    if params[:previous].to_s =~ /(\d+)\z/
      @previous = Park.my.find_by_id(Regexp.last_match[1]) || Regexp.last_match[1].to_i
    end

    respond_with(@park)
  end

  # POST /Parks
  #----------------------------------------------------------------------------
  def create
    @comment_body = params[:comment_body]

    respond_with(@park) do |_format|
      if @park.save
        @park.add_comment_by_user(@comment_body, current_user)
        @parks = get_parks
      end
    end
  end

  # PUT /Parks/1
  #----------------------------------------------------------------------------
  def update
    respond_with(@park) do |_format|
      # Must set access before user_ids, because user_ids= method depends on access value.
      @park.access = resource_params[:access] if resource_params[:access]
    end
  end

  # DELETE /Parks/1
  #----------------------------------------------------------------------------
  def destroy
    @park.destroy

    respond_with(@park) do |format|
      format.html { respond_to_destroy(:html) }
      format.js   { respond_to_destroy(:ajax) }
    end
  end

  # PUT /Parks/1/attach
  #----------------------------------------------------------------------------
  # Handled by EntitiesController :attach

  # PUT /Parks/1/discard
  #----------------------------------------------------------------------------
  # Handled by EntitiesController :discard

  # POST /Parks/auto_complete/query                                    AJAX
  #----------------------------------------------------------------------------
  # Handled by ApplicationController :auto_complete

  # GET /Parks/redraw                                                  AJAX
  #----------------------------------------------------------------------------
  def redraw
    current_user.pref[:parks_per_page] = params[:per_page] if params[:per_page]
    current_user.pref[:parks_sort_by]  = Park.sort_by_map[params[:sort_by]] if params[:sort_by]
    @parks = get_parks(page: 1, per_page: params[:per_page])
    set_options # Refresh options

    respond_with(@parks) do |format|
      format.js { render :index }
    end
  end

  # POST /Parks/filter                                                 AJAX
  #----------------------------------------------------------------------------
  def filter
    session[:parks_filter] = params[:status]
    @parks = get_parks(page: 1, per_page: params[:per_page])

    respond_with(@parks) do |format|
      format.js { render :index }
    end
  end

  private

  #----------------------------------------------------------------------------
  alias_method :get_parks, :get_list_of_records

  #----------------------------------------------------------------------------
  def respond_to_destroy(method)
    if method == :ajax
      @parks = get_parks
      if @parks.blank?
        @parks = get_parks(page: current_page - 1) if current_page > 1
        render(:index) && return
      end
      # At this point render destroy.js
    else # :html request
      self.current_page = 1
      flash[:notice] = t(:msg_asset_deleted, @park.name)
      redirect_to parks_path
    end
  end

end
