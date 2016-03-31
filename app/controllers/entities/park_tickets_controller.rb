# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
class ParkTicketsController < EntitiesController
  before_action :get_park_tickets, only: [:new, :create, :edit, :update]

  autocomplete :park, :name

  # GET /Park_tickets
  #----------------------------------------------------------------------------
  def index
    @park_tickets = get_park_tickets(page: params[:page], per_page: params[:per_page])

    respond_with @park_tickets do |format|
      format.xls { render layout: 'header' }
      format.csv { render csv: @park_tickets }
    end
  end

  # GET /Park_tickets/1
  # AJAX /Park_tickets/1
  # XLS /Park_tickets/1
  # XLS /Park_tickets/1
  # CSV /Park_tickets/1
  # RSS /Park_tickets/1
  # ATOM /Park_tickets/1
  #----------------------------------------------------------------------------
  def show
    respond_with(@park_ticket) do |format|
      format.html do
      end

      format.js do
      end

      format.xls do
      end

      format.csv do
        render csv: @park_ticket
      end

      format.rss do
      end

      format.atom do
      end
    end
  end

  # GET /Park_tickets/new
  # GET /Park_tickets/new.json
  # GET /Park_tickets/new.xml                                                 AJAX
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

    respond_with(@park_ticket)
  end

  # GET /Park_tickets/1/edit                                                  AJAX
  #----------------------------------------------------------------------------
  def edit
    if params[:previous].to_s =~ /(\d+)\z/
      @previous = Park_ticket.my.find_by_id(Regexp.last_match[1]) || Regexp.last_match[1].to_i
    end

    respond_with(@park_ticket)
  end

  # POST /Park_tickets
  #----------------------------------------------------------------------------
  def create
    @comment_body = params[:comment_body]

    respond_with(@park_ticket) do |_format|
      if @park_ticket.save
        @park_tickets = get_park_tickets
      end
    end
  end

  # PUT /Park_tickets/1
  #----------------------------------------------------------------------------
  def update
    respond_with(@park_ticket) do |_format|
      @park_ticket.update_attributes(params.require(:park_ticket).permit!)
      @park_ticket.save
    end
  end

  # DELETE /Park_tickets/1
  #----------------------------------------------------------------------------
  def destroy
    @park_ticket.destroy

    respond_with(@park_ticket) do |format|
      format.html { respond_to_destroy(:html) }
      format.js   { respond_to_destroy(:ajax) }
    end
  end

  # PUT /Park_tickets/1/attach
  #----------------------------------------------------------------------------
  # Handled by EntitiesController :attach

  # PUT /Park_tickets/1/discard
  #----------------------------------------------------------------------------
  # Handled by EntitiesController :discard

  # POST /Park_tickets/auto_complete/query                                    AJAX
  #----------------------------------------------------------------------------
  # Handled by ApplicationController :auto_complete

  # GET /Park_tickets/redraw                                                  AJAX
  #----------------------------------------------------------------------------
  def redraw
    current_user.pref[:park_tickets_per_page] = params[:per_page] if params[:per_page]
    current_user.pref[:park_tickets_sort_by]  = Park_ticket.sort_by_map[params[:sort_by]] if params[:sort_by]
    @park_tickets = get_park_tickets(page: 1, per_page: params[:per_page])
    set_options # Refresh options

    respond_with(@park_tickets) do |format|
      format.js { render :index }
    end
  end

  # POST /Park_tickets/filter                                                 AJAX
  #----------------------------------------------------------------------------
  def filter
    session[:park_tickets_filter] = params[:status]
    @park_tickets = get_park_tickets(page: 1, per_page: params[:per_page])

    respond_with(@park_tickets) do |format|
      format.js { render :index }
    end
  end

  private

  #----------------------------------------------------------------------------
  alias_method :get_park_tickets, :get_list_of_records

  #----------------------------------------------------------------------------
  def respond_to_destroy(method)
    if method == :ajax
      @park_tickets = get_park_tickets
      if @park_tickets.blank?
        @park_tickets = get_park_tickets(page: current_page - 1) if current_page > 1
        render(:index) && return
      end
      # At this point render destroy.js
    else # :html request
      self.current_page = 1
      flash[:notice] = t(:msg_asset_deleted, @park_ticket.name)
      redirect_to park_tickets_path
    end
  end

end
