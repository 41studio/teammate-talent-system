class DashboardsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @company = current_user.company
    if @company.present?
      @drafted_jobs = @company.jobs.drafted_jobs.sort_job_by_updated_at
      @published_jobs = @company.jobs.published_jobs.sort_job_by_updated_at
      @closed_jobs = @company.jobs.closed_jobs.sort_job_by_updated_at
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
        @time = Applicant.get_first_created_applicant.map(&:created_at)
      end

      if params[:filter_by_stage]
        filter_by_stage = params[:filter_by_stage].values
      elsif params[:filter_by_consideration].present? && params[:filter_by_consideration].values == ["disqualified"]
        filter_by_stage = ["disqualified"]
      else
        filter_by_stage = Applicant.applicant_statuses
      end
      
      if params[:filter_by_job]
        filter_by_job = params[:filter_by_job].values
      else
        filter_by_job = @jobs.ids
      end
      
      if params[:filter_by_gender]
        filter_by_gender = params[:filter_by_gender].values
      else
        filter_by_gender = ["Male","Female"]
      end

      @search = Applicant.search(params[:q])
      @applicants = @search.result.filter_applicant(@jobs.ids,@time,filter_by_gender,filter_by_stage,filter_by_job).page(params[:page]).per(10)
      @applicant_filter_result_count = @search.result.filter_applicant(@jobs.ids,@time,filter_by_gender,filter_by_stage,filter_by_job).count
      @applicant_total = Applicant.total_applicant(current_user.company_id, @jobs).count
      

      respond_to do |format|
        format.html
        format.js { render 'dashboards/filter_applicant' }
      end
    else
      flash[:notice] = "No Applicant here"
    end
  end
end