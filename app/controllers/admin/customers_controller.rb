class Admin::CustomersController < ApplicationController
  before_action "set_current_tab('admin/customers')", only: [:index, :show]

  load_and_authorize_resource # handles all security

  def index
    load_resources
    render :locals => { :customers => @customers }
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
