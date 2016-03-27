# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
class TransportsController < EntitiesController

  # GET /Transports
  #----------------------------------------------------------------------------
  def index
    @transports = get_transports(page: params[:page], per_page: params[:per_page])

    respond_with @transports do |format|
      format.xls { render layout: 'header' }
      format.csv { render csv: @transports }
    end
  end

  # GET /Transports/1
  # AJAX /Transports/1
  # XLS /Transports/1
  # XLS /Transports/1
  # CSV /Transports/1
  # RSS /Transports/1
  # ATOM /Transports/1
  #----------------------------------------------------------------------------
  def show
    respond_with(@transport) do |format|
      format.html do
        @comment = Comment.new
        @timeline = timeline(@transport)
      end

      format.js do
        @comment = Comment.new
        @timeline = timeline(@transport)
      end

      format.xls do
      end

      format.csv do
        render csv: @transport
      end

      format.rss do
      end

      format.atom do
      end
    end
  end

  # GET /Transports/new
  # GET /Transports/new.json
  # GET /Transports/new.xml                                                 AJAX
  #----------------------------------------------------------------------------
  def new
    @transport.attributes = { user: current_user, access: Setting.default_access, assigned_to: nil }

    if params[:related]
      model, id = params[:related].split('_')
      if related = model.classify.constantize.my.find_by_id(id)
        instance_variable_set("@#{model}", related)
      else
        respond_to_related_not_found(model) && return
      end
    end

    respond_with(@transport)
  end

  # GET /Transports/1/edit                                                  AJAX
  #----------------------------------------------------------------------------
  def edit
    if params[:previous].to_s =~ /(\d+)\z/
      @previous = Transport.my.find_by_id(Regexp.last_match[1]) || Regexp.last_match[1].to_i
    end

    respond_with(@transport)
  end

  # POST /Transports
  #----------------------------------------------------------------------------
  def create
    @comment_body = params[:comment_body]

    respond_with(@transport) do |_format|
      if @transport.save
        @transport.add_comment_by_user(@comment_body, current_user)
        @transports = get_transports
      end
    end
  end

  # PUT /Transports/1
  #----------------------------------------------------------------------------
  def update
    respond_with(@transport) do |_format|
      # Must set access before user_ids, because user_ids= method depends on access value.
      @transport.access = resource_params[:access] if resource_params[:access]
    end
  end

  # DELETE /Transports/1
  #----------------------------------------------------------------------------
  def destroy
    @transport.destroy

    respond_with(@transport) do |format|
      format.html { respond_to_destroy(:html) }
      format.js   { respond_to_destroy(:ajax) }
    end
  end

  # PUT /Transports/1/attach
  #----------------------------------------------------------------------------
  # Handled by EntitiesController :attach

  # PUT /Transports/1/discard
  #----------------------------------------------------------------------------
  # Handled by EntitiesController :discard

  # POST /Transports/auto_complete/query                                    AJAX
  #----------------------------------------------------------------------------
  # Handled by ApplicationController :auto_complete

  # GET /Transports/redraw                                                  AJAX
  #----------------------------------------------------------------------------
  def redraw
    current_user.pref[:transports_per_page] = params[:per_page] if params[:per_page]
    current_user.pref[:transports_sort_by]  = Transport.sort_by_map[params[:sort_by]] if params[:sort_by]
    @transports = get_transports(page: 1, per_page: params[:per_page])
    set_options # Refresh options

    respond_with(@transports) do |format|
      format.js { render :index }
    end
  end

  # POST /Transports/filter                                                 AJAX
  #----------------------------------------------------------------------------
  def filter
    session[:transports_filter] = params[:status]
    @transports = get_transports(page: 1, per_page: params[:per_page])

    respond_with(@transports) do |format|
      format.js { render :index }
    end
  end

  private

  #----------------------------------------------------------------------------
  alias_method :get_transports, :get_list_of_records

  #----------------------------------------------------------------------------
  def respond_to_destroy(method)
    if method == :ajax
      @transports = get_transports
      if @transports.blank?
        @transports = get_transports(page: current_page - 1) if current_page > 1
        render(:index) && return
      end
      # At this point render destroy.js
    else # :html request
      self.current_page = 1
      flash[:notice] = t(:msg_asset_deleted, @transport.name)
      redirect_to transports_path
    end
  end

end
