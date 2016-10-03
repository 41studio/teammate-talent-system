class JobsController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:index, :show]
  before_action :set_job, only: [:show, :edit, :update, :destroy]
  before_action :set_company, only: [:new, :edit]
  before_action :set_collection, only: [:new, :edit, :create, :update]

  # GET /jobs
  # GET /jobs.json
  def index
    @jobs = Job.all
    if params[:search]
      @jobs = Job.search(params[:search]).order("created_at DESC")
    else
      @jobs = Job.all.order('created_at DESC')
    end
  end

  # GET /jobs/1
  # GET /jobs/1.json
  def show
  end

  # GET /jobs/new
  def new
    @company = Company.find(params[:company_id])
    @job = @company.jobs.build
    @form = [@company,@job]
  end

  # GET /jobs/1/edit
  def edit
    @company = Company.find(set_job.company_id)
    @job = @company.jobs.find(params[:id])
    @form = @job
  end

  # POST /jobs
  # POST /jobs.json
  def create
    @job = set_company.jobs.new(job_params)
    @job.status = "draft"
    respond_to do |format|
      if @job.save
        format.html { redirect_to job_path(@job), notice: 'Job was successfully created.' }
        format.json { render :show, status: :created, location: @job }
      else
        format.html { render :new }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jobs/1
  # PATCH/PUT /jobs/1.json
  def update
    respond_to do |format|
      if @job.update(job_params)
        format.html { redirect_to @job, notice: 'Job was successfully updated.' }
        format.json { render :show, status: :ok, location: @job }
      else
        format.html { render :edit }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.json
  def destroy
    @job.destroy
    respond_to do |format|
      format.html { redirect_to company_path(@job.company_id), notice: 'Job was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upgrade_status
    @job = Job.find(params[:id])
    @job.status = params[:status]
    if @job.status == "published" or @job.status == "closed"
      if @job.save!
        respond_to do |format|
          format.html { redirect_to job_path(@job.id), notice: 'Job was successfully '+@job.status+'.' }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to job_path(@job.id), notice: 'Invalid command!' }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.find(params[:id])
    end

    def set_company
      @company = Company.find(params[:company_id])
    end

    def set_collection
      @experience_collection = ExperienceList.all.collect {|i| [i.experience, i.id]}
      @function_collection = FunctionList.all.collect {|i| [i.function, i.id]}
      @employment_type_collection = EmploymentTypeList.all.collect {|i| [i.employment_type, i.id]}
      @industry_collection = IndustryList.all.collect {|i| [i.industry, i.id]}
      @education_collection = EducationList.all.collect {|i| [i.education, i.id]}
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def job_params
      params.require(:job).permit(:job_title, :departement, :job_code, :country, :state, :city, :zip_code, :min_salary, :max_salary, :curency, :job_description, :job_requirement, :benefits, :experience_list_id, :function_list_id, :employment_type_list_id, :industry_list_id, :education_list_id, :job_search_keyword)
    end
end
