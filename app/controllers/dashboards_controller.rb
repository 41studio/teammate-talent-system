class DashboardsController < ApplicationController
	before_action :authenticate_user!
  
  def index
    @company = current_user.company
    if @company.present?
      @drafted_jobs = @company.jobs.drafted_jobs
      @published_jobs = @company.jobs.published_jobs
      @closed_jobs = @company.jobs.closed_jobs
    else
      redirect_to new_company_path
    end
  end

  def applicant
    if current_user.company.present?
     @jobs = current_user.company.jobs
     @search = Applicant.search(params[:q])
     @applicants = @search.result.where(job_id: @jobs)
     @applicant_count = Applicant.all
    else
      flash[:notice] = "No Applicant here"
    end
  end
end