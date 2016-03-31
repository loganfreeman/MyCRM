# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
class SnacksController < EntitiesController
  before_action :get_snacks, only: [:new, :create, :edit, :update]

  # GET /Snacks
  #----------------------------------------------------------------------------
  def index
    @snacks = get_snacks(page: params[:page], per_page: params[:per_page])

    respond_with @snacks do |format|
      format.xls { render layout: 'header' }
      format.csv { render csv: @snacks }
    end
  end

  # GET /Snacks/1
  # AJAX /Snacks/1
  # XLS /Snacks/1
  # XLS /Snacks/1
  # CSV /Snacks/1
  # RSS /Snacks/1
  # ATOM /Snacks/1
  #----------------------------------------------------------------------------
  def show
    respond_with(@snack) do |format|
      format.html do
      end

      format.js do
      end

      format.xls do
      end

      format.csv do
        render csv: @snack
      end

      format.rss do
      end

      format.atom do
      end
    end
  end

  # GET /Snacks/new
  # GET /Snacks/new.json
  # GET /Snacks/new.xml                                                 AJAX
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

    respond_with(@snack)
  end

  # GET /Snacks/1/edit                                                  AJAX
  #----------------------------------------------------------------------------
  def edit
    if params[:previous].to_s =~ /(\d+)\z/
      @previous = Snack.my.find_by_id(Regexp.last_match[1]) || Regexp.last_match[1].to_i
    end

    respond_with(@snack)
  end

  # POST /Snacks
  #----------------------------------------------------------------------------
  def create
    @comment_body = params[:comment_body]

    respond_with(@snack) do |_format|
      if @snack.save
        @snacks = get_snacks
      end
    end
  end

  # PUT /Snacks/1
  #----------------------------------------------------------------------------
  def update
    respond_with(@snack) do |_format|
      @snack.update_attributes(params.require(:snack).permit!)
      @snack.save
    end
  end

  # DELETE /Snacks/1
  #----------------------------------------------------------------------------
  def destroy
    @snack.destroy

    respond_with(@snack) do |format|
      format.html { respond_to_destroy(:html) }
      format.js   { respond_to_destroy(:ajax) }
    end
  end

  # PUT /Snacks/1/attach
  #----------------------------------------------------------------------------
  # Handled by EntitiesController :attach

  # PUT /Snacks/1/discard
  #----------------------------------------------------------------------------
  # Handled by EntitiesController :discard

  # POST /Snacks/auto_complete/query                                    AJAX
  #----------------------------------------------------------------------------
  # Handled by ApplicationController :auto_complete

  # GET /Snacks/redraw                                                  AJAX
  #----------------------------------------------------------------------------
  def redraw
    current_user.pref[:snacks_per_page] = params[:per_page] if params[:per_page]
    current_user.pref[:snacks_sort_by]  = Snack.sort_by_map[params[:sort_by]] if params[:sort_by]
    @snacks = get_snacks(page: 1, per_page: params[:per_page])
    set_options # Refresh options

    respond_with(@snacks) do |format|
      format.js { render :index }
    end
  end

  # POST /Snacks/filter                                                 AJAX
  #----------------------------------------------------------------------------
  def filter
    session[:snacks_filter] = params[:status]
    @snacks = get_snacks(page: 1, per_page: params[:per_page])

    respond_with(@snacks) do |format|
      format.js { render :index }
    end
  end

  private

  #----------------------------------------------------------------------------
  alias_method :get_snacks, :get_list_of_records

  #----------------------------------------------------------------------------
  def respond_to_destroy(method)
    if method == :ajax
      @snacks = get_snacks
      if @snacks.blank?
        @snacks = get_snacks(page: current_page - 1) if current_page > 1
        render(:index) && return
      end
      # At this point render destroy.js
    else # :html request
      self.current_page = 1
      flash[:notice] = t(:msg_asset_deleted, @snack.name)
      redirect_to snacks_path
    end
  end

end
