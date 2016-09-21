class DashboardsController < ApplicationController
	before_action :authenticate_user!
  
  def index
  	@companies = Company.joins(:users).where(id: current_user.company_id)
  	@published_jobs = Job.joins(:company).where(company_id: @companies)
  end

  def show

  end
end
