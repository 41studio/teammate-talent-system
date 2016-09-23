class DashboardsController < ApplicationController
	before_action :authenticate_user!
  
  def index
  	@companies = Company.joins(:users).where(id: current_user.company_id)
  	@drafted_jobs = Job.joins(:company).where(company_id: @companies, jobs: {status: "draft"})
  	@published_jobs = Job.joins(:company).where(company_id: @companies, jobs: {status: "published"})
  	@closed_jobs = Job.joins(:company).where(company_id: @companies, jobs: {status: "closed"})
  end

  def show

  end
end
