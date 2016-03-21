class Admin::CustomersController < Admin::ApplicationController
  before_action "set_current_tab('admin/customers')", only: [:index, :show]

  load_and_authorize_resource # handles all security

  def index
    load_resources
    respond_with @customers do |format|
      format.xls { render layout: 'header' }
      format.csv { render csv: @customers }
    end
  end

  # GET /admin/customers/1
  # GET /admin/customers/1.xml
  #----------------------------------------------------------------------------
  def show
    respond_with(@customer)
  end

  def edit
    respond_with(@customer)
  end

  # GET /users/new
  # GET /users/new.js
  #----------------------------------------------------------------------------
  def new
    respond_with(@customer)
  end

  def create
    @customer = Customer.create(customer_params)
    respond_with(@customer)
  end

  def update
    @customer = Customer.find(params[:id])
    @customer.attributes = customer_params
    @customer.save

    respond_with(@customer)
  end

  def load_resources
    @customers = Customer.all
  end

  def customer_params
    params[:customer].permit(
      :email,
      :first_name,
      :last_name,
      :company,
      :phone,
    )
  end
end
