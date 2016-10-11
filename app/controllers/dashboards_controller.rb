class DashboardsController < ApplicationController
	before_action :authenticate_user!
  
  def index
    @company = current_user.company
    if @company.present?
      @drafted_jobs = current_user.company.jobs.drafted_jobs
      @published_jobs = current_user.company.jobs.published_jobs
      @closed_jobs = current_user.company.jobs.closed_jobs
    else
      redirect_to new_company_path
    end
  end

  def applicant
    if current_user.company.present?
    @jobs = current_user.company.jobs
    @applicants = Applicant.where(job_id: @jobs)
    else
      flash[:notice] = "No Applicant here"
    end
  end
end