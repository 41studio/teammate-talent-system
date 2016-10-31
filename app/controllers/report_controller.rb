class ReportController < ApplicationController
  before_action :chart_data, only: [:index, :download_report]
  def index
    @data = chart_data
    respond_to do |format|
      format.html
      format.js { render 'report/filter_report' }
    end
  end

  def download_report
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "report",
               margin: { top: 20, bottom: 20, left: 20, right: 20 },
               layout: 'pdf.html.slim',
               header: { html: { template: 'report/report_header', layout: 'pdf.html.slim' } },
               locals: {data: chart_data }
      end
    end
  end

  private
    def chart_data
      @jobs = current_user.company.jobs.published_and_closed_jobs
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
      elsif params[:filter_by_consideration].present? && params[:filter_by_consideration].values == Applicant::DISQUALIFIED
        filter_by_stage = Applicant::DISQUALIFIED
      else
        filter_by_stage = Applicant::STATUSES.map{|key, val| key.to_s}
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
      @data = Applicant.join_job.filter_report_applicant(current_user.company_id, filter_by_job, filter_by_stage, filter_by_gender).group(time).count
    end
end
