class ReportController < ApplicationController
  def index
  	@applied_applicant_by_day = Applicant.group('date(created_at)').count
  	@jobs = current_user.company.jobs.where(job_status: "published")
  end
end
