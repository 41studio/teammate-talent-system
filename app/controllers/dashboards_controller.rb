class DashboardsController < ApplicationController
	before_action :authenticate_user!
  
  def index
  	@companys = Company.joins(:users).where(id: current_user.company_id)
  end

  def show

  end
end
