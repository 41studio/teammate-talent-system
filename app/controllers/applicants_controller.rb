class ApplicantsController < ApplicationController

  skip_before_filter :authenticate_user!, only: [:create, :new]
  before_action :set_applicant, only: [:show, :edit, :update, :destroy]
  before_action :set_job, only: [:new, :edit]
  
  # GET /applicants
  # GET /applicants.json
  def index
    @applicants = Applicant.all
  end

  # GET /applicants/1
  # GET /applicants/1.json
  def show

  end

  # GET /applicants/new
  def new
    @applicant = Applicant.new
    @applicant.educations.build
    @applicant.experiences.build
  end

  # GET /applicants/1/edit
  def edit
  end

  # POST /applicants
  # POST /applicants.json
  def create
    @job = Job.find(params[:job_id])
    @applicant = @job.applicants.new(applicant_params)
    @applicant.status = "applied"
    respond_to do |format|
      if @applicant.save
        format.html { redirect_to job_path(@job), notice: 'Applicant was successfully created.' }
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
    @job = Job.joins(:applicants).where(applicants: { status: status }).find_by(id: params[:job_id])
  end

  def phase
    @job = Job.find(params[:job_id])
    @applicant = Applicant.find(params[:applicant_id])
    @applicant.status = params[:phase]
    if @applicant.status == "applied" or @applicant.status == "phone_screen" or @applicant.status == "interview" or @applicant.status == "offer" or @applicant.status == "hired" or @applicant.status == "disqualified"
      if @applicant.save!
        respond_to do |format|
          format.html { redirect_to job_applicant_path(@job, @applicant) }
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def applicant_params
      params.require(:applicant).permit(:name, :gender, :date_birth, :email, :headline, :phone, :address, :photo, :resume, educations_attributes: [:name_school, :field_study, :degree], experiences_attributes: [:name_company, :industry, :title, :summary])
    end
end
