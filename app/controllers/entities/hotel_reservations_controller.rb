# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
class HotelReservationsController < EntitiesController
  before_action :get_hotel_reservations, only: [:new, :create, :edit, :update]

  # GET /HotelReservations
  #----------------------------------------------------------------------------
  def index
    @hotel_reservations = get_hotel_reservations(page: params[:page], per_page: params[:per_page])

    respond_with @hotel_reservations do |format|
      format.xls { render layout: 'header' }
      format.csv { render csv: @hotel_reservations }
    end
  end

  # GET /HotelReservations/1
  # AJAX /HotelReservations/1
  # XLS /HotelReservations/1
  # XLS /HotelReservations/1
  # CSV /HotelReservations/1
  # RSS /HotelReservations/1
  # ATOM /HotelReservations/1
  #----------------------------------------------------------------------------
  def show
    respond_with(@hotel_reservation) do |format|
      format.html do
      end

      format.js do
      end

      format.xls do
      end

      format.csv do
        render csv: @hotel_reservation
      end

      format.rss do
      end

      format.atom do
      end
    end
  end

  # GET /HotelReservations/new
  # GET /HotelReservations/new.json
  # GET /HotelReservations/new.xml                                                 AJAX
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

    respond_with(@hotel_reservation)
  end

  # GET /HotelReservations/1/edit                                                  AJAX
  #----------------------------------------------------------------------------
  def edit
    if params[:previous].to_s =~ /(\d+)\z/
      @previous = HotelReservation.my.find_by_id(Regexp.last_match[1]) || Regexp.last_match[1].to_i
    end

    respond_with(@hotel_reservation)
  end

  # POST /HotelReservations
  #----------------------------------------------------------------------------
  def create
    @comment_body = params[:comment_body]

    respond_with(@hotel_reservation) do |_format|
      if @hotel_reservation.save
        @hotel_reservations = get_hotel_reservations
      end
    end
  end

  # PUT /HotelReservations/1
  #----------------------------------------------------------------------------
  def update
    respond_with(@hotel_reservation) do |_format|
      @hotel_reservation.update_attributes(params.require(:hotel_reservation).permit!)
      @hotel_reservation.save
    end
  end

  # DELETE /HotelReservations/1
  #----------------------------------------------------------------------------
  def destroy
    @hotel_reservation.destroy

    respond_with(@hotel_reservation) do |format|
      format.html { respond_to_destroy(:html) }
      format.js   { respond_to_destroy(:ajax) }
    end
  end

  # PUT /HotelReservations/1/attach
  #----------------------------------------------------------------------------
  # Handled by EntitiesController :attach

  # PUT /HotelReservations/1/discard
  #----------------------------------------------------------------------------
  # Handled by EntitiesController :discard

  # POST /HotelReservations/auto_complete/query                                    AJAX
  #----------------------------------------------------------------------------
  # Handled by ApplicationController :auto_complete

  # GET /HotelReservations/redraw                                                  AJAX
  #----------------------------------------------------------------------------
  def redraw
    current_user.pref[:hotel_reservations_per_page] = params[:per_page] if params[:per_page]
    current_user.pref[:hotel_reservations_sort_by]  = HotelReservation.sort_by_map[params[:sort_by]] if params[:sort_by]
    @hotel_reservations = get_hotel_reservations(page: 1, per_page: params[:per_page])
    set_options # Refresh options

    respond_with(@hotel_reservations) do |format|
      format.js { render :index }
    end
  end

  # POST /HotelReservations/filter                                                 AJAX
  #----------------------------------------------------------------------------
  def filter
    session[:hotel_reservations_filter] = params[:status]
    @hotel_reservations = get_hotel_reservations(page: 1, per_page: params[:per_page])

    respond_with(@hotel_reservations) do |format|
      format.js { render :index }
    end
  end

  private

  #----------------------------------------------------------------------------
  alias_method :get_hotel_reservations, :get_list_of_records

  #----------------------------------------------------------------------------
  def respond_to_destroy(method)
    if method == :ajax
      @hotel_reservations = get_hotel_reservations
      if @hotel_reservations.blank?
        @hotel_reservations = get_hotel_reservations(page: current_page - 1) if current_page > 1
        render(:index) && return
      end
      # At this point render destroy.js
    else # :html request
      self.current_page = 1
      flash[:notice] = t(:msg_asset_deleted, @hotel_reservation.name)
      redirect_to hotel_reservations_path
    end
  end

end
