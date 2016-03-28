# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
class ExibitionsController < EntitiesController

  # GET /Exibition
  #----------------------------------------------------------------------------
  def index
    @exibitions = get_exibitions(page: params[:page], per_page: params[:per_page])

    respond_with @exibitions do |format|
      format.xls { render layout: 'header' }
      format.csv { render csv: @exibitions }
    end
  end

  # GET /Exibition/1
  # AJAX /Exibition/1
  # XLS /Exibition/1
  # XLS /Exibition/1
  # CSV /Exibition/1
  # RSS /Exibition/1
  # ATOM /Exibition/1
  #----------------------------------------------------------------------------
  def show
    respond_with(@exibition) do |format|
      format.html do
        @comment = Comment.new
        @timeline = timeline(@exibition)
      end

      format.js do
        @comment = Comment.new
        @timeline = timeline(@exibition)
      end

      format.xls do
      end

      format.csv do
        render csv: @exibition
      end

      format.rss do
      end

      format.atom do
      end
    end
  end

  # GET /Exibition/new
  # GET /Exibition/new.json
  # GET /Exibition/new.xml                                                 AJAX
  #----------------------------------------------------------------------------
  def new
    @exibition.attributes = { user: current_user, access: Setting.default_access, assigned_to: nil }

    if params[:related]
      model, id = params[:related].split('_')
      if related = model.classify.constantize.my.find_by_id(id)
        instance_variable_set("@#{model}", related)
      else
        respond_to_related_not_found(model) && return
      end
    end

    respond_with(@exibition)
  end

  # GET /Exibition/1/edit                                                  AJAX
  #----------------------------------------------------------------------------
  def edit
    if params[:previous].to_s =~ /(\d+)\z/
      @previous = Conference.my.find_by_id(Regexp.last_match[1]) || Regexp.last_match[1].to_i
    end

    respond_with(@exibition)
  end

  # POST /Exibition
  #----------------------------------------------------------------------------
  def create
    @comment_body = params[:comment_body]

    respond_with(@exibition) do |_format|
      if @exibition.save
        @exibition.add_comment_by_user(@comment_body, current_user)
        @exibitions = get_exibitions
      end
    end
  end

  # PUT /Exibition/1
  #----------------------------------------------------------------------------
  def update
    respond_with(@exibition) do |_format|
      # Must set access before user_ids, because user_ids= method depends on access value.
      @exibition.access = resource_params[:access] if resource_params[:access]
    end
  end

  # DELETE /Exibition/1
  #----------------------------------------------------------------------------
  def destroy
    @exibition.destroy

    respond_with(@exibition) do |format|
      format.html { respond_to_destroy(:html) }
      format.js   { respond_to_destroy(:ajax) }
    end
  end

  # PUT /Exibition/1/attach
  #----------------------------------------------------------------------------
  # Handled by EntitiesController :attach

  # PUT /Exibition/1/discard
  #----------------------------------------------------------------------------
  # Handled by EntitiesController :discard

  # POST /Exibition/auto_complete/query                                    AJAX
  #----------------------------------------------------------------------------
  # Handled by ApplicationController :auto_complete

  # GET /Exibition/redraw                                                  AJAX
  #----------------------------------------------------------------------------
  def redraw
    current_user.pref[:exibitions_per_page] = params[:per_page] if params[:per_page]
    current_user.pref[:exibitions_sort_by]  = Conference.sort_by_map[params[:sort_by]] if params[:sort_by]
    @exibitions = get_exibitions(page: 1, per_page: params[:per_page])
    set_options # Refresh options

    respond_with(@exibitions) do |format|
      format.js { render :index }
    end
  end

  # POST /Exibition/filter                                                 AJAX
  #----------------------------------------------------------------------------
  def filter
    session[:exibitions_filter] = params[:status]
    @exibitions = get_exibitions(page: 1, per_page: params[:per_page])

    respond_with(@exibitions) do |format|
      format.js { render :index }
    end
  end

  private

  #----------------------------------------------------------------------------
  alias_method :get_exibitions, :get_list_of_records

  #----------------------------------------------------------------------------
  def respond_to_destroy(method)
    if method == :ajax
      @exibitions = get_exibitions
      if @exibitions.blank?
        @exibitions = get_exibitions(page: current_page - 1) if current_page > 1
        render(:index) && return
      end
      # At this point render destroy.js
    else # :html request
      self.current_page = 1
      flash[:notice] = t(:msg_asset_deleted, @exibition.name)
      redirect_to exibitions_path
    end
  end

end
