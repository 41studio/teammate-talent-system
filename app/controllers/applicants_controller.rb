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
    applicant = Applicant.find(params[:id])
    @recruitment_level = applicant.applicant_recruitment_level
    @disabled_level = applicant.disable_level(params[:id])
    @new_comment = Comment.build_from(applicant, current_user.id, "")
    @url = company_job_applicant_comments_path(params[:company_id], params[:job_id], params[:id])
    @comments = applicant.comment_threads
  end

  # GET /applicants/new
  def new
    @company = set_company
    @form = @company.jobs.find(params[:job_id]).applicants.new
    @applicant = Applicant.new
    @applicant.educations.build
    @applicant.experiences.build
    @url = company_job_applicants_path(params[:company_id], params[:job_id])
  end

  # GET /applicants/1/edit
  def edit
  end

  def send_email
    @applicant = Applicant.find(params[:id])
    @job = Job.find(params[:job_id])
    SendMail.sample_email(@applicant, params[:subject], params[:body]).deliver
    redirect_to company_job_applicant_path(@job.company_id, @job, @applicant)
  end

  # POST /applicants
  # POST /applicants.json
  def create
    @job = Job.find(params[:job_id])
    @applicant = @job.applicants.new(applicant_params)
    @form = @applicant
    @applicant.status = "applied"
    respond_to do |format|
      if @applicant.save
        SendMail.send_email_after_apply(@applicant, @job).deliver
        format.html { redirect_to company_job_path(@job.company_id, @job), notice: 'Applicant was successfully created.' }

        #push notification

        app = Rpush::Gcm::App.new
        app.name = "teamhire"
        app.auth_key = "AIzaSyCWX1_asXP_gdqYYc-fb2_Uor2pODB_bDw"
        app.connections = 1
        app.save!

        n = Rpush::Gcm::Notification.new
        n.app = Rpush::Gcm::App.find_by_name("teamhire")
        n.registration_ids = ["238618199031-2pjffhh7adjvgjflof8ecpbha50dnhjt.apps.googleusercontent.com"]
        n.data = { message: "hi mom!" }
        n.priority = 'high'        # Optional, can be either 'normal' or 'high'
        n.content_available = true # Optional
        # Optional notification payload. See the reference below for more keys you can use!
        n.notification = { body: 'great match!',
                           title: 'Portugal vs. Denmark',
                           icon: 'myicon'
                         }
        n.save!

        #end of push notification

        format.html { redirect_to company_job_path(@job.company_id, @job), notice: 'Applicant was successfully created.' }
        format.json { render :show, status: :created, location: @applicant }
      else
        format.html { render :new }
        format.json { render json: @applicant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /applicants/1
  # PATCH/PUT /applicants/1.json
  def update
    respond_to do |format|
      if @applicant.update(applicant_params)
        format.html { redirect_to @applicant, notice: 'Applicant was successfully updated.' }
        format.json { render :show, status: :ok, location: @applicant }
      else
        format.html { render :edit }
        format.json { render json: @applicant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /applicants/1
  # DELETE /applicants/1.json
  def destroy
    @applicant.destroy
    respond_to do |format|
      format.html { redirect_to applicants_url, notice: 'Applicant was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def applicant_status
    status = params[:status]
    @applicants = Applicant.where(applicants: { status: status, job_id: params[:job_id] })
  end

  def phase
    @job = Job.find(params[:job_id])
    @applicant = Applicant.find(params[:applicant_id])
    @applicant.status = params[:phase]
    if @applicant.status == "applied" or @applicant.status == "phone_screen" or @applicant.status == "interview" or @applicant.status == "offer" or @applicant.status == "hired" or @applicant.status == "disqualified"
      if @applicant.save!
        respond_to do |format|
          format.html { redirect_to company_job_applicant_path(@job.company_id, @job, @applicant) }
          format.js {}
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to job_applicant_path(@job, @applicant), notice: "invalid!" }
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
      @job = Job.find(params[:job_id])
    end

    def set_company
      @company = Company.find(params[:company_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def applicant_params
      params.require(:applicant).permit(:name, :gender, :date_birth, :email, :headline, :phone, :address, :photo, :resume, educations_attributes: [:name_school, :field_study, :degree], experiences_attributes: [:name_company, :industry, :title, :summary])
    end
end
