class ItinerariesController < EntitiesController

  alias_method :get_itineraries, :get_list_of_records

  def index
    if params[:id].present?
      @itinerary = Itinerary.find_by_id(params[:id])
      respond_with @itinerary do |format|
        format.xls { render layout: 'header' }
        format.csv { render csv: @itinerary }
      end
    else
      @itineraries = get_itineraries(page: params[:page], per_page: params[:per_page])
      respond_with @itineraries do |format|
        format.xls { render layout: 'header' }
        format.csv { render csv: @itineraries }
      end
    end
  end

  def show
    respond_with @itinerary do |format|
      format.xls { render layout: 'header' }
      format.csv { render csv: @itinerary }
    end
  end

  # GET /itineraries/new
  #----------------------------------------------------------------------------
  def new
    @itinerary.attributes = { user: current_user, access: Setting.default_access, assigned_to: nil }

    if params[:related]
      model, id = params[:related].split('_')
      instance_variable_set("@#{model}", model.classify.constantize.find(id))
    end

    respond_with(@itinerary)
  end

  def add_itinerary_item
    respond_with(@itinerary)
  end

  # GET /itineraries/1/edit                                                   AJAX
  #----------------------------------------------------------------------------
  def edit
    if params[:previous].to_s =~ /(\d+)\z/
      @previous = Itinerary.my.find_by_id(Regexp.last_match[1]) || Regexp.last_match[1].to_i
    end

    respond_with(@itinerary)
  end

  # POST /itineraries
  #----------------------------------------------------------------------------
  def create
    @comment_body = params[:comment_body]
    respond_with(@itinerary) do |_format|
      if @itinerary.save
        @itinerary.add_comment_by_user(@comment_body, current_user)
        # None: itinerary can only be created from the Itinerarys index page, so we
        # don't have to check whether we're on the index page.
        @itineraries = get_itineraries
      end
    end
  end

  # PUT /itineraries/1
  #----------------------------------------------------------------------------
  def update
    respond_with(@itinerary) do |_format|
      # Must set access before user_ids, because user_ids= method depends on access value.
      @itinerary.access = params[:itinerary][:access] if params[:itinerary][:access]
      get_data_for_sidebar if @itinerary.update_attributes(resource_params)
    end
  end

  # DELETE /itineraries/1
  #----------------------------------------------------------------------------
  def destroy
    @itinerary.destroy

    respond_with(@itinerary) do |format|
      format.html { respond_to_destroy(:html) }
      format.js   { respond_to_destroy(:ajax) }
    end
  end

  # PUT /itineraries/1/attach
  #----------------------------------------------------------------------------
  # Handled by EntitiesController :attach

  # PUT /itineraries/1/discard
  #----------------------------------------------------------------------------
  # Handled by EntitiesController :discard

  # POST /itineraries/auto_complete/query                                     AJAX
  #----------------------------------------------------------------------------
  # Handled by ApplicationController :auto_complete

  # GET /itineraries/redraw                                                   AJAX
  #----------------------------------------------------------------------------
  def redraw
    current_user.pref[:itineraries_per_page] = params[:per_page] if params[:per_page]
    current_user.pref[:itineraries_sort_by]  = Itinerary.sort_by_map[params[:sort_by]] if params[:sort_by]
    @itineraries = get_itineraries(page: 1, per_page: params[:per_page])
    set_options # Refresh options

    respond_with(@itineraries) do |format|
      format.js { render :index }
    end
  end

  # POST /itineraries/filter                                                  AJAX
  #----------------------------------------------------------------------------
  def filter
    session[:itineraries_filter] = params[:category]
    @itineraries = get_itineraries(page: 1, per_page: params[:per_page])

    respond_with(@itineraries) do |format|
      format.js { render :index }
    end
  end

  private

  #----------------------------------------------------------------------------
  alias_method :get_itineraries, :get_list_of_records

  #----------------------------------------------------------------------------
  def respond_to_destroy(method)
    if method == :ajax
      @itineraries = get_itineraries
      get_data_for_sidebar
      if @itineraries.empty?
        @itineraries = get_itineraries(page: current_page - 1) if current_page > 1
        render(:index) && return
      end
      # At this point render default destroy.js
    else # :html request
      self.current_page = 1 # Reset current page to 1 to make sure it stays valid.
      flash[:notice] = t(:msg_asset_deleted, @itinerary.name)
      redirect_to itineraries_path
    end
  end

end
