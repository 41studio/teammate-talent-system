class ReportController < ApplicationController
  def index
    case params[:group_by_time]
    when "week"
      @group = 'week(applicants.created_at)'
      @x_title = "Week"
    when "month"
      @group = 'month(applicants.created_at)'
      @x_title = "Month"
    when "year"
      @group = 'year(applicants.created_at)'
      @x_title = "Year"
    else
      @group = 'date(applicants.created_at)'
      @x_title = "Date"
    end
    @applied_applicant_by_day = Applicant.joins(:job).where(jobs: {company_id: current_user.company_id}).group(@group).count
    @jobs = current_user.company.jobs.where(job_status: "published")
    if params[:group_by_time]
      respond_to do |format|
        format.js { render 'report/sort_by_time' }
      end
    end
  end
end
