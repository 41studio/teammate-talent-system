# == Schema Information
#
# Table name: applicants
#
#  id         :integer          not null, primary key
#  name       :string(255)      default(""), not null
#  gender     :string(255)      default(""), not null
#  date_birth :date             not null
#  email      :string(255)      default(""), not null
#  headline   :string(255)      default(""), not null
#  phone      :string(255)      default(""), not null
#  address    :string(255)      default(""), not null
#  photo      :string(255)      default(""), not null
#  resume     :string(255)      default(""), not null
#  status     :string(255)      default("Applied"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  job_id     :integer
#


class ApplicantsController < ApplicationController

  skip_before_filter :authenticate_user!, only: [:create, :new]
  before_filter :user_allowed, only: [:show, :edit, :update, :destroy, :applicant_status]
  before_filter :applicant_status_allowed, only: [:applicant_status, :show]
  before_filter :applicant_allowed, only: [:show]
  before_action :set_applicant, only: [:show, :edit, :update, :destroy]
  before_action :set_job
  before_action :set_company, only: [:new]
  
  # GET /applicants
  # GET /applicants.json
  def index
    @applicants = Applicant.all
  end

  # GET /applicants/1
  # GET /applicants/1.json
  def show
    @applicant = Applicant.find(params[:id])
    @recruitment_level = Applicant::STATUSES
    @disqualified = Applicant::DISQUALIFIED
    @disabled_level = @applicant.disable_level
    @new_comment = Comment.build_from(@applicant, current_user.id, "")
    @url = company_job_applicant_comments_path(params[:company_id], params[:job_id], params[:id])
    # @comments = applicant.comment_threads
    @old_schedules = @applicant.schedules.old_schedules
    @latest_schedules = @applicant.schedules.latest_schedules
  end

  # GET /applicants/new
  def new
    @company = set_company
    @form = @company.jobs.friendly.find(params[:job_id]).applicants.new
    @applicant = Applicant.new
    @applicant.educations.build
    @applicant.experiences.build
    @education = Education.new
    @experience = Experience.new
    @url = company_job_applicants_path(params[:company_id], params[:job_id])
  end

  # GET /applicants/1/edit
  def edit
  end

  def send_email
    @applicant = Applicant.find(params[:id])
    @job = Job.find(params[:job_id])
    SendMail.delay.send_email_to_applicant(@applicant, params[:subject], params[:body])
    redirect_to company_job_applicant_path(@job.company_id, @job, @applicant)
  end

  # POST /applicants
  # POST /applicants.json
  def create
    @job = Job.friendly.find(params[:job_id])
    @applicant = @job.applicants.new(applicant_params)
    @form = @applicant
    @applicant.status = "applied"
    if @applicant.save
      @applicant.send_notification!("New Applicant")
      SendMail.delay.send_email_after_apply(@applicant, @job)
      SendMail.send_email_to_company_after_applicant_applied(@job.company.users, @job, @applicant)
      redirect_to company_job_path(@job.company.friendly_id, @job), notice: 'Applicant was successfully created.'
    else    
      render :new
    end
  end

  # PATCH/PUT /applicants/1
  # PATCH/PUT /applicants/1.json
  def update
    if @applicant.update(applicant_params)
      redirect_to @applicant, notice: 'Applicant was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /applicants/1
  # DELETE /applicants/1.json
  def destroy
    @applicant.destroy
    redirect_to applicants_url, notice: 'Applicant was successfully destroyed.'
    head :no_content
  end

  def applicant_status
    @jobs = current_user.company.jobs
     if params[:filter_by]
        case params[:filter_by]
        when "week"
          @time = 1.week.ago
        when "month"
          @time = 1.month.ago
        when "year"
          @time = 1.year.ago
        when "three_month"
          @time = 3.month.ago
        end
      else
        @time = Applicant.order("created_at ASC LIMIT 1").map(&:created_at)
      end
        
      if params[:filter_by_gender]
        filter_by_gender = params[:filter_by_gender].values
      else
        filter_by_gender = ["Male","Female"]
      end
      
      @job = Job.friendly.find(params[:job_id])
      status = params[:status]
      @status = status
      @company_id = params[:company_id]
      # @job_id = params[:job_id]
     
      @search = Applicant.search(params[:q])
      @applicants = @search.result.where("job_id IN (?) and created_at >= ? 
        and gender IN (?) and status IN (?)", @job.id, @time, filter_by_gender, status).page(params[:page]).per(10)
      
      @applicant_filter_result_count = @search.result.where("job_id IN (?) and created_at >= ?
       and gender IN (?) and status IN (?)", @job.id, @time, filter_by_gender, params[:status]).count
    
      # @applicant_total = Applicant.total_applicant(current_user.company_id, @jobs).count
      @applicant_total = Applicant.total_applicant_status(current_user.company_id, @job.id , status).count
      respond_to do |format|
        format.html
        format.js { render 'applicants/filter_applicant_status' }
    end
    # @job_title = Job.find(params[:job_id])
    # status = params[:status]
    # @status = status
    # @company_id = params[:company_id]
    # @job_id = params[:job_id]
    # @search = Applicant.search(params[:q])
    # @applicants = @search.result.where(applicants: { status: status, job_id: params[:job_id] })
    # @applicant_count = Applicant.total_applicant_status(current_user.company_id, @job_id , status)
  end

  def phase
    @job = Job.find(params[:job_id])
    @applicant = Applicant.find(params[:id])
    status = params[:phase]
    if Applicant::STATUSES.has_key? status.to_sym 
      if @applicant.update_attribute(:status, status)
        SendMail.delay.send_mail_after_change_status(@applicant, @job)
        respond_to do |format|
          format.html { redirect_to company_job_applicant_path(@job.company_id, @job, @applicant) }
          format.js {}
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to company_job_applicant_path(@job.company_id, @job, @applicant), notice: "invalid!" }
        format.js {}
      end
    end 
  end

  def disqualified
    @job = Job.friendly.find(params[:job_id])
    @applicant = Applicant.find(params[:id])
    if @applicant.update_attribute(:status, Applicant::DISQUALIFIED)
      respond_to do |format|
        format.html { redirect_to company_job_applicant_path(@job.company_id, @job, @applicant) }
        format.js {}
      end
    else
      respond_to do |format|
        format.html { redirect_to company_job_applicant_path(@job.company_id, @job, @applicant), notice: "invalid!" }
        format.js {}
      end
    end 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_applicant
      @applicant = Applicant.find(params[:id])
    end

    def set_job
      @job = Job.friendly.find(params[:job_id])
    end

    def set_company
        @company = Company.friendly.find(params[:company_id])
    end

    def user_allowed
      if current_user.company_id != set_company.id
        redirect_to dashboards_path
      end
    end

    def applicant_status_allowed
      company_id = params[:company_id]
      if set_job.company.friendly_id != company_id
        redirect_to dashboards_path
      end   
    end

    def applicant_allowed
      job_id = params[:job_id]
      if set_applicant.job.friendly_id != job_id
        redirect_to dashboards_path
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def applicant_params
      params.require(:applicant).permit(:name, :gender, :date_birth, :email, :headline, :phone, :address, :photo, :resume, educations_attributes: [:name_school, :field_study, :degree], experiences_attributes: [:name_company, :industry, :title, :summary])
    end
end
