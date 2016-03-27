class ResourcesController < ApplicationController
  before_action :require_user
  before_action :set_current_tab, only: [:index, :show]
  before_action :update_sidebar, only: :index
  before_action :require_user, except: [:toggle, :timezone]

  def update_sidebar
  end

  # Ensure view is allowed
  #----------------------------------------------------------------------------
  def view
    view = params[:view]
  end

  def index
    @view = view
    if @view == 'client'
      redirect_to accounts_path and return
    end
    @my_accounts = Account.visible_on_dashboard(current_user).includes(:user, :tags).by_name
    @my_tasks = Task.visible_on_dashboard(current_user).includes(:user, :asset).by_due_at
    @my_opportunities = Opportunity.visible_on_dashboard(current_user).includes(:account, :user, :tags).by_closes_on.by_amount
  end

end
