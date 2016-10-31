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
        @time = Applicant.get_first_created_applicant.map(&:created_at)
      end
      
      if params[:filter_by_stage]
        filter_by_stage = params[:filter_by_stage].values
      elsif params[:filter_by_consideration].present? && params[:filter_by_consideration].values == Applicant::DISQUALIFIED
        filter_by_stage = Applicant::DISQUALIFIED
      else
        filter_by_stage = Applicant::STATUSES.map{|key, val| key.to_s}
      end
    
      if params[:filter_by_gender]
        filter_by_gender = params[:filter_by_gender].values
      else
        filter_by_gender = ["Male","Female"]
      end
      
      if params[:filter_by_job]
        filter_by_job = params[:filter_by_job].values
      else
        filter_by_job = @jobs.select(:job_title)
      end

      @search = Applicant.search(params[:q])
      @applicants = @search.result.filter_applicant(@jobs.ids,@time,filter_by_gender,filter_by_stage,filter_by_job).page(params[:page]).per(10)
      @applicant_filter_result_count = @search.result.filter_applicant(@jobs.ids,@time,filter_by_gender,filter_by_stage,filter_by_job).count
      @applicant_total = Applicant.total_applicant(current_user.company_id, @jobs).count
      # disqualified = filter_by_stage = ["disqualified"]
      # applicant_disqualified = @search.result.filter_applicant(@jobs.ids,@time,filter_by_gender,disqualified,filter_by_job).count
      # @applicant_total = @applicant_total - applicant_disqualified
      

      respond_to do |format|
        format.html
        format.js { render 'dashboards/filter_applicant' }
      end
    else
      flash[:notice] = "No Applicant here"
    end
  end
end