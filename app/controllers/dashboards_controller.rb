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
      if params[:filter_by]
        case params[:filter_by]
        when "week"
          @time = 1.week.ago
        when "month"
          @time = 1.month.ago
        when "year"
          @time = 1.year.ago
        end
      else
        @time = Applicant.order("created_at ASC LIMIT 1").map(&:created_at)
      end
      
      if params[:filter_by_stage]
        filter_by_stage = params[:filter_by_stage].values
      else
        filter_by_stage = ["applied","phone_screen","interview","offer","hired"]
      end
    
      if params[:filter_by_gender]
        filter_by_gender = params[:filter_by_gender].values
      else
        filter_by_gender = ["Male","Female"]
      end

      @search = Applicant.search(params[:q])
      @applicants = @search.result.where("job_id IN (?) and created_at >= ? and gender IN (?) and status IN (?)", @jobs.ids, @time, filter_by_gender, filter_by_stage).page(params[:page]).per(10)
      @applicant_filter_result_count = @search.result.where("job_id IN (?) and created_at >= ? and gender IN (?) and status IN (?)", @jobs.ids, @time, filter_by_gender, filter_by_stage).count
      @applicant_total = Applicant.total_applicant(current_user.company_id, @jobs).count
      respond_to do |format|
        format.html
        format.js { render 'applicants/filter_applicant' }
      end
    else
      flash[:notice] = "No Applicant here"
    end
  end
end