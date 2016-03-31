# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
class TransportationsController < EntitiesController
  before_action :get_transportations, only: [:new, :create, :edit, :update]

  # GET /Transportations
  #----------------------------------------------------------------------------
  def index
    @transportations = get_transportations(page: params[:page], per_page: params[:per_page])

    respond_with @transportations do |format|
      format.xls { render layout: 'header' }
      format.csv { render csv: @transportations }
    end
  end

  # GET /Transportations/1
  # AJAX /Transportations/1
  # XLS /Transportations/1
  # XLS /Transportations/1
  # CSV /Transportations/1
  # RSS /Transportations/1
  # ATOM /Transportations/1
  #----------------------------------------------------------------------------
  def show
    respond_with(@transportation) do |format|
      format.html do
      end

      format.js do
      end

      format.xls do
      end

      format.csv do
        render csv: @transportation
      end

      format.rss do
      end

      format.atom do
      end
    end
  end

  # GET /Transportations/new
  # GET /Transportations/new.json
  # GET /Transportations/new.xml                                                 AJAX
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

    respond_with(@transportation)
  end

  # GET /Transportations/1/edit                                                  AJAX
  #----------------------------------------------------------------------------
  def edit
    if params[:previous].to_s =~ /(\d+)\z/
      @previous = Transportation.my.find_by_id(Regexp.last_match[1]) || Regexp.last_match[1].to_i
    end

    respond_with(@transportation)
  end

  # POST /Transportations
  #----------------------------------------------------------------------------
  def create
    @comment_body = params[:comment_body]

    respond_with(@transportation) do |_format|
      if @transportation.save
        @transportations = get_transportations
      end
    end
  end

  # PUT /Transportations/1
  #----------------------------------------------------------------------------
  def update
    respond_with(@transportation) do |_format|
      @transportation.update_attributes(params.require(:transportation).permit!)
      @transportation.save
    end
  end

  # DELETE /Transportations/1
  #----------------------------------------------------------------------------
  def destroy
    @transportation.destroy

    respond_with(@transportation) do |format|
      format.html { respond_to_destroy(:html) }
      format.js   { respond_to_destroy(:ajax) }
    end
  end

  # PUT /Transportations/1/attach
  #----------------------------------------------------------------------------
  # Handled by EntitiesController :attach

  # PUT /Transportations/1/discard
  #----------------------------------------------------------------------------
  # Handled by EntitiesController :discard

  # POST /Transportations/auto_complete/query                                    AJAX
  #----------------------------------------------------------------------------
  # Handled by ApplicationController :auto_complete

  # GET /Transportations/redraw                                                  AJAX
  #----------------------------------------------------------------------------
  def redraw
    current_user.pref[:transportations_per_page] = params[:per_page] if params[:per_page]
    current_user.pref[:transportations_sort_by]  = Transportation.sort_by_map[params[:sort_by]] if params[:sort_by]
    @transportations = get_transportations(page: 1, per_page: params[:per_page])
    set_options # Refresh options

    respond_with(@transportations) do |format|
      format.js { render :index }
    end
  end

  # POST /Transportations/filter                                                 AJAX
  #----------------------------------------------------------------------------
  def filter
    session[:transportations_filter] = params[:status]
    @transportations = get_transportations(page: 1, per_page: params[:per_page])

    respond_with(@transportations) do |format|
      format.js { render :index }
    end
  end

  private

  #----------------------------------------------------------------------------
  alias_method :get_transportations, :get_list_of_records

  #----------------------------------------------------------------------------
  def respond_to_destroy(method)
    if method == :ajax
      @transportations = get_transportations
      if @transportations.blank?
        @transportations = get_transportations(page: current_page - 1) if current_page > 1
        render(:index) && return
      end
      # At this point render destroy.js
    else # :html request
      self.current_page = 1
      flash[:notice] = t(:msg_asset_deleted, @transportation.name)
      redirect_to transportations_path
    end
  end

end
