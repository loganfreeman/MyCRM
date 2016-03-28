# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
class ConferencesController < EntitiesController

  # GET /Conferences
  #----------------------------------------------------------------------------
  def index
    @conferences = get_conferences(page: params[:page], per_page: params[:per_page])

    respond_with @conferences do |format|
      format.xls { render layout: 'header' }
      format.csv { render csv: @conferences }
    end
  end

  # GET /Conferences/1
  # AJAX /Conferences/1
  # XLS /Conferences/1
  # XLS /Conferences/1
  # CSV /Conferences/1
  # RSS /Conferences/1
  # ATOM /Conferences/1
  #----------------------------------------------------------------------------
  def show
    respond_with(@conference) do |format|
      format.html do
        @comment = Comment.new
        @timeline = timeline(@conference)
      end

      format.js do
        @comment = Comment.new
        @timeline = timeline(@conference)
      end

      format.xls do
      end

      format.csv do
        render csv: @conference
      end

      format.rss do
      end

      format.atom do
      end
    end
  end

  # GET /Conferences/new
  # GET /Conferences/new.json
  # GET /Conferences/new.xml                                                 AJAX
  #----------------------------------------------------------------------------
  def new
    @conference.attributes = { user: current_user, access: Setting.default_access, assigned_to: nil }

    if params[:related]
      model, id = params[:related].split('_')
      if related = model.classify.constantize.my.find_by_id(id)
        instance_variable_set("@#{model}", related)
      else
        respond_to_related_not_found(model) && return
      end
    end

    respond_with(@conference)
  end

  # GET /Conferences/1/edit                                                  AJAX
  #----------------------------------------------------------------------------
  def edit
    if params[:previous].to_s =~ /(\d+)\z/
      @previous = Conference.my.find_by_id(Regexp.last_match[1]) || Regexp.last_match[1].to_i
    end

    respond_with(@conference)
  end

  # POST /Conferences
  #----------------------------------------------------------------------------
  def create
    @comment_body = params[:comment_body]

    respond_with(@conference) do |_format|
      if @conference.save
        @conference.add_comment_by_user(@comment_body, current_user)
        @conferences = get_conferences
      end
    end
  end

  # PUT /Conferences/1
  #----------------------------------------------------------------------------
  def update
    respond_with(@conference) do |_format|
      # Must set access before user_ids, because user_ids= method depends on access value.
      @conference.access = resource_params[:access] if resource_params[:access]
    end
  end

  # DELETE /Conferences/1
  #----------------------------------------------------------------------------
  def destroy
    @conference.destroy

    respond_with(@conference) do |format|
      format.html { respond_to_destroy(:html) }
      format.js   { respond_to_destroy(:ajax) }
    end
  end

  # PUT /Conferences/1/attach
  #----------------------------------------------------------------------------
  # Handled by EntitiesController :attach

  # PUT /Conferences/1/discard
  #----------------------------------------------------------------------------
  # Handled by EntitiesController :discard

  # POST /Conferences/auto_complete/query                                    AJAX
  #----------------------------------------------------------------------------
  # Handled by ApplicationController :auto_complete

  # GET /Conferences/redraw                                                  AJAX
  #----------------------------------------------------------------------------
  def redraw
    current_user.pref[:conferences_per_page] = params[:per_page] if params[:per_page]
    current_user.pref[:conferences_sort_by]  = Conference.sort_by_map[params[:sort_by]] if params[:sort_by]
    @conferences = get_conferences(page: 1, per_page: params[:per_page])
    set_options # Refresh options

    respond_with(@conferences) do |format|
      format.js { render :index }
    end
  end

  # POST /Conferences/filter                                                 AJAX
  #----------------------------------------------------------------------------
  def filter
    session[:conferences_filter] = params[:status]
    @conferences = get_conferences(page: 1, per_page: params[:per_page])

    respond_with(@conferences) do |format|
      format.js { render :index }
    end
  end

  private

  #----------------------------------------------------------------------------
  alias_method :get_conferences, :get_list_of_records

  #----------------------------------------------------------------------------
  def respond_to_destroy(method)
    if method == :ajax
      @conferences = get_conferences
      if @conferences.blank?
        @conferences = get_conferences(page: current_page - 1) if current_page > 1
        render(:index) && return
      end
      # At this point render destroy.js
    else # :html request
      self.current_page = 1
      flash[:notice] = t(:msg_asset_deleted, @conference.name)
      redirect_to conferences_path
    end
  end

end
