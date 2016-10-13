class ReportController < ApplicationController
  def index
  	@applied_applicant_by_day = Applicant.group_by_day(:created_at).count
  	@jobs = current_user.company.jobs.where(job_status: "published")
  end

  def show
  end
end
