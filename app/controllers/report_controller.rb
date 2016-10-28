class ReportController < ApplicationController
  def index
    @jobs = current_user.company.jobs.published_jobs
    if params[:filter_by]
      case params[:filter_by]
      when "week"
        time = 'week(applicants.created_at)'
        @x_title = "Week"
      when "month"
        time = 'month(applicants.created_at)'
        @x_title = "Month"
      when "year"
        time = 'year(applicants.created_at)'
        @x_title = "Year"
      end
    else
      time = 'date(applicants.created_at)'
      @x_title = "Date"
    end
    
    if params[:filter_by_stage]
      filter_by_stage = params[:filter_by_stage].values
    else
      filter_by_stage = ["applied","phone_screen","interview","offer","hired"]
    end

    if params[:filter_by_stage]
      filter_by_stage = params[:filter_by_stage].values
    elsif params[:filter_by_consideration].present? && params[:filter_by_consideration].values == ["disqualified"]
      filter_by_stage = ["disqualified"]
    else
      filter_by_stage = Applicant::STATUSES.map{|key, val| key.to_s}
    end
    
    if params[:filter_by_job]
      filter_by_job = params[:filter_by_job].values
    else
      filter_by_job = @jobs.job_title
    end
    
    if params[:filter_by_gender]
      filter_by_gender = params[:filter_by_gender].values
    else
      filter_by_gender = ["Male","Female"]
    end
    
    @data = Applicant.join_job.filter_report_applicant(current_user.company_id, filter_by_job, filter_by_stage, filter_by_gender).group(time).count
    # asfd
    respond_to do |format|
      format.html
      format.js { render 'report/filter_report' }
    end
  end

end
