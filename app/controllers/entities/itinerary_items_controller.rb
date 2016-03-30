class ItineraryItemsController < EntitiesController

  alias_method :get_itinerary_items, :get_list_of_records

  def index
    @itinerary_items = get_itinerary_items(page: params[:page], per_page: params[:per_page])
    respond_with @itinerary_items do |format|
      format.xls { render layout: 'header' }
      format.csv { render csv: @itinerary_items }
    end
  end

  # GET /itinerary_items/new
  #----------------------------------------------------------------------------
  def new
    if params[:related]
      model, id = params[:related].split('_')
      instance_variable_set("@#{model}", model.classify.constantize.find(id))
    end

    respond_with(@itinerary_item)
  end

  # GET /itinerary_items/1/edit                                                   AJAX
  #----------------------------------------------------------------------------
  def edit
    if params[:previous].to_s =~ /(\d+)\z/
      @previous = ItineraryItem.my.find_by_id(Regexp.last_match[1]) || Regexp.last_match[1].to_i
    end

    respond_with(@itinerary_item)
  end

  def add_meal
    @meal = @itinerary_item.meals.new
    respond_with(@meal)
  end

  # POST /itinerary_items
  #----------------------------------------------------------------------------
  def create
    @comment_body = params[:comment_body]
    respond_with(@itinerary_item) do |_format|
      if @itinerary_item.save
        # None: itinerary_item can only be created from the ItineraryItems index page, so we
        # don't have to check whether we're on the index page.
        @itinerary_items = get_itinerary_items
      end
    end
  end

  # PUT /itinerary_items/1
  #----------------------------------------------------------------------------
  def update
    respond_with(@itinerary_item) do |_format|
      # Must set access before user_ids, because user_ids= method depends on access value.
      @itinerary_item.update_attributes(params.require(:itinerary_item).permit!)
      @itinerary_item.save
    end
  end

  # DELETE /itinerary_items/1
  #----------------------------------------------------------------------------
  def destroy
    @itinerary_item.destroy

    respond_with(@itinerary_item) do |format|
      format.html { respond_to_destroy(:html) }
      format.js   { respond_to_destroy(:ajax) }
    end
  end

  # PUT /itinerary_items/1/attach
  #----------------------------------------------------------------------------
  # Handled by EntitiesController :attach

  # PUT /itinerary_items/1/discard
  #----------------------------------------------------------------------------
  # Handled by EntitiesController :discard

  # POST /itinerary_items/auto_complete/query                                     AJAX
  #----------------------------------------------------------------------------
  # Handled by ApplicationController :auto_complete

  # GET /itinerary_items/redraw                                                   AJAX
  #----------------------------------------------------------------------------
  def redraw
    current_user.pref[:itinerary_items_per_page] = params[:per_page] if params[:per_page]
    current_user.pref[:itinerary_items_sort_by]  = ItineraryItem.sort_by_map[params[:sort_by]] if params[:sort_by]
    @itinerary_items = get_itinerary_items(page: 1, per_page: params[:per_page])
    set_options # Refresh options

    respond_with(@itinerary_items) do |format|
      format.js { render :index }
    end
  end

  # POST /itinerary_items/filter                                                  AJAX
  #----------------------------------------------------------------------------
  def filter
    session[:itinerary_items_filter] = params[:category]
    @itinerary_items = get_itinerary_items(page: 1, per_page: params[:per_page])

    respond_with(@itinerary_items) do |format|
      format.js { render :index }
    end
  end

  private

  #----------------------------------------------------------------------------
  alias_method :get_itinerary_items, :get_list_of_records

  #----------------------------------------------------------------------------
  def respond_to_destroy(method)
    if method == :ajax
      @itinerary_items = get_itinerary_items
      if @itinerary_items.empty?
        @itinerary_items = get_itinerary_items(page: current_page - 1) if current_page > 1
        render(:index) && return
      end
      # At this point render default destroy.js
    else # :html request
      self.current_page = 1 # Reset current page to 1 to make sure it stays valid.
      flash[:notice] = t(:msg_asset_deleted, @itinerary_item.name)
      redirect_to itinerary_items_path
    end
  end

end
