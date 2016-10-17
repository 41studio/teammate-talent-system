class ReportController < ApplicationController
  def index
  	if params[:group_by] == "week"
  		group = Applicant.group('week(created_at)')
  	elsif params[:group_by] == "month"
  		group = Applicant.group('month(created_at)')
  	elsif params[:group_by] == "year"
  		group = Applicant.group('year(created_at)')
  	else
  		group = Applicant.group('date(created_at)')
  	end
  	@applied_applicant_by_day = group.count
  	@jobs = current_user.company.jobs.where(job_status: "published")
  	if params[:group_by].present?
  		respond_to do |format|
  			format.js { render 'report/index' }
  		end
  	end
  end
end
