# == Schema Information
#
# Table name: jobs
#
#  id                      :integer          not null, primary key
#  job_title               :string(255)      default(""), not null
#  departement             :string(255)      default(""), not null
#  job_code                :string(255)      default(""), not null
#  country                 :string(255)      default(""), not null
#  state                   :string(255)      default(""), not null
#  city                    :string(255)      default(""), not null
#  zip_code                :string(255)      default(""), not null
#  min_salary              :integer          default(0), not null
#  max_salary              :integer          default(0), not null
#  curency                 :string(255)      default(""), not null
#  job_description         :text(65535)      not null
#  job_requirement         :text(65535)      not null
#  benefits                :text(65535)      not null
#  job_search_keyword      :string(255)      default(""), not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  company_id              :integer
#  education_list_id       :integer
#  employment_type_list_id :integer
#  experience_list_id      :integer
#  function_list_id        :integer
#  industry_list_id        :integer
#  status                  :string(255)
#

class JobsController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:index, :show]
  before_filter :user_allowed, only: [:edit, :update, :destroy, :create, :new]
  before_filter :job_allowed, only: [:show]
  before_action :set_job, only: [:show, :edit, :update, :destroy]
  before_action :set_company, only: [:new]
  before_action :set_collection, only: [:new, :edit, :create, :update]

  def index
    @jobs = Job.all
    if params[:search]
      @jobs = Job.search(params[:search]).order("created_at DESC")
    else
      @jobs = Job.all.order('created_at DESC')
    end
  end

  def show; end

  def new
    @job = set_company.jobs.new
    @url = company_jobs_path(params[:company_id])
  end

  def edit
    @job = set_company.jobs.find(set_job)
    @url = company_job_path(@job.company_id, @job)
  end

  def create
    @url = company_jobs_path(params[:company_id])
    @job = set_company.jobs.new(job_params)
    @job.status = "draft"
    if @job.save
      redirect_to company_job_path(params[:company_id], @job), notice: 'Job was successfully created.'
    else
      render :new
    end
  end

  def update
    @url = company_job_path(@job.company_id, @job)
    if @job.update(job_params)
      redirect_to company_job_path(@job.company_id, @job), notice: 'Job was successfully updated.'
    else
      render :edit
    end
  end

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
        redirect_to company_job_path(@job.company_id, @job), notice: 'Job was successfully '+@job.status+'.'
      end
    else
      redirect_to company_job_path(@job.company_id, @job), notice: 'Invalid command!'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.friendly.find(params[:id])
    end

    def set_company
      @company = Company.friendly.find(params[:company_id])
    end

    def set_collection
      @experience_collection = ExperienceList.all.collect {|i| [i.experience, i.id]}
      @function_collection = FunctionList.all.collect {|i| [i.function, i.id]}
      @employment_type_collection = EmploymentTypeList.all.collect {|i| [i.employment_type, i.id]}
      @industry_collection = IndustryList.all.collect {|i| [i.industry, i.id]}
      @education_collection = EducationList.all.collect {|i| [i.education, i.id]}
    end

    def user_allowed
      if current_user.company_id != set_company.id
        redirect_to dashboards_path
      end
    end
    
    def job_allowed
      company_id = params[:company_id]
      if set_job.company.friendly_id != company_id
        redirect_to root_path, notice: 'No Job available' 
      end
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def job_params
      params.require(:job).permit(:job_title, :departement, :job_code, :country, :state, :city, :zip_code, :min_salary, :max_salary, :curency, :job_description, :job_requirement, :benefits, :experience_list_id, :function_list_id, :employment_type_list_id, :industry_list_id, :education_list_id, :job_search_keyword)
    end
end
