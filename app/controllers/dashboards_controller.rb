class DashboardsController < ApplicationController
	before_action :authenticate_user!
  
  def index
  	@company = current_user.company
  	@drafted_jobs = current_user.company.jobs.drafted_jobs
  	@published_jobs = current_user.company.jobs.published_jobs
  	@closed_jobs = current_user.company.jobs.closed_jobs
  end
end
