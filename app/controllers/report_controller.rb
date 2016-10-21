class ReportController < ApplicationController
  def index
    @jobs = current_user.company.jobs.where(job_status: "published")

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

    if params[:filter_by_consideration] && params[:filter_by_consideration].values == "disqualified"
      filter_by_stage = params[:filter_by_consideration].values
    else
      if params[:filter_by_stage]
        filter_by_stage = params[:filter_by_stage].values
      else
        filter_by_stage = ["applied","phone_screen","interview","offer","hired"]
      end
    end
    
    if params[:filter_by_job]
      filter_by_job = params[:filter_by_job].values
    else
      filter_by_job = @jobs.select(:job_title)
    end
    
    if params[:filter_by_gender]
      filter_by_gender = params[:filter_by_gender].values
    else
      filter_by_gender = ["Male","Female"]
    end

    @data = Applicant.joins(:job).where(jobs: {company_id: current_user.company_id, job_title: filter_by_job}, status: filter_by_stage, gender: filter_by_gender ).group(time).count
    respond_to do |format|
      format.html
      format.js { render 'report/filter_report' }
    end
  end

end
