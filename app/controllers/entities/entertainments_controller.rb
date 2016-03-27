# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
class EntertainmentsController < EntitiesController

  # GET /Entertainments
  #----------------------------------------------------------------------------
  def index
    @entertainments = get_entertainments(page: params[:page], per_page: params[:per_page])

    respond_with @entertainments do |format|
      format.xls { render layout: 'header' }
      format.csv { render csv: @entertainments }
    end
  end

  # GET /Entertainments/1
  # AJAX /Entertainments/1
  # XLS /Entertainments/1
  # XLS /Entertainments/1
  # CSV /Entertainments/1
  # RSS /Entertainments/1
  # ATOM /Entertainments/1
  #----------------------------------------------------------------------------
  def show
    respond_with(@entertainment) do |format|
      format.html do
        @comment = Comment.new
        @timeline = timeline(@entertainment)
      end

      format.js do
        @comment = Comment.new
        @timeline = timeline(@entertainment)
      end

      format.xls do
      end

      format.csv do
        render csv: @entertainment
      end

      format.rss do
      end

      format.atom do
      end
    end
  end

  # GET /Entertainments/new
  # GET /Entertainments/new.json
  # GET /Entertainments/new.xml                                                 AJAX
  #----------------------------------------------------------------------------
  def new
    @entertainment.attributes = { user: current_user, access: Setting.default_access, assigned_to: nil }

    if params[:related]
      model, id = params[:related].split('_')
      if related = model.classify.constantize.my.find_by_id(id)
        instance_variable_set("@#{model}", related)
      else
        respond_to_related_not_found(model) && return
      end
    end

    respond_with(@entertainment)
  end

  # GET /Entertainments/1/edit                                                  AJAX
  #----------------------------------------------------------------------------
  def edit
    if params[:previous].to_s =~ /(\d+)\z/
      @previous = Entertainment.my.find_by_id(Regexp.last_match[1]) || Regexp.last_match[1].to_i
    end

    respond_with(@entertainment)
  end

  # POST /Entertainments
  #----------------------------------------------------------------------------
  def create
    @comment_body = params[:comment_body]

    respond_with(@entertainment) do |_format|
      if @entertainment.save
        @entertainment.add_comment_by_user(@comment_body, current_user)
        @entertainments = get_entertainments
      end
    end
  end

  # PUT /Entertainments/1
  #----------------------------------------------------------------------------
  def update
    respond_with(@entertainment) do |_format|
      # Must set access before user_ids, because user_ids= method depends on access value.
      @entertainment.access = resource_params[:access] if resource_params[:access]
    end
  end

  # DELETE /Entertainments/1
  #----------------------------------------------------------------------------
  def destroy
    @entertainment.destroy

    respond_with(@entertainment) do |format|
      format.html { respond_to_destroy(:html) }
      format.js   { respond_to_destroy(:ajax) }
    end
  end

  # PUT /Entertainments/1/attach
  #----------------------------------------------------------------------------
  # Handled by EntitiesController :attach

  # PUT /Entertainments/1/discard
  #----------------------------------------------------------------------------
  # Handled by EntitiesController :discard

  # POST /Entertainments/auto_complete/query                                    AJAX
  #----------------------------------------------------------------------------
  # Handled by ApplicationController :auto_complete

  # GET /Entertainments/redraw                                                  AJAX
  #----------------------------------------------------------------------------
  def redraw
    current_user.pref[:entertainments_per_page] = params[:per_page] if params[:per_page]
    current_user.pref[:entertainments_sort_by]  = Entertainment.sort_by_map[params[:sort_by]] if params[:sort_by]
    @entertainments = get_entertainments(page: 1, per_page: params[:per_page])
    set_options # Refresh options

    respond_with(@entertainments) do |format|
      format.js { render :index }
    end
  end

  # POST /Entertainments/filter                                                 AJAX
  #----------------------------------------------------------------------------
  def filter
    session[:entertainments_filter] = params[:status]
    @entertainments = get_entertainments(page: 1, per_page: params[:per_page])

    respond_with(@entertainments) do |format|
      format.js { render :index }
    end
  end

  private

  #----------------------------------------------------------------------------
  alias_method :get_entertainments, :get_list_of_records

  #----------------------------------------------------------------------------
  def respond_to_destroy(method)
    if method == :ajax
      @entertainments = get_entertainments
      if @entertainments.blank?
        @entertainments = get_entertainments(page: current_page - 1) if current_page > 1
        render(:index) && return
      end
      # At this point render destroy.js
    else # :html request
      self.current_page = 1
      flash[:notice] = t(:msg_asset_deleted, @entertainment.name)
      redirect_to entertainments_path
    end
  end

end
