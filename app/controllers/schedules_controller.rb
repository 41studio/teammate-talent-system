# == Schema Information
#
# Table name: schedules
#
#  id                    :integer          not null, primary key
#  date                  :datetime         not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  applicant_id          :integer
#  category              :string(255)      not null
#  notify_applicant_flag :string(255)      default("false"), not null
#

class SchedulesController < ApplicationController
  before_action :set_applicant, :set_location, :set_assignee_collection, except: [:index]
  before_action :set_category_collection
  before_action :new_schedule_path, only: [:new, :create]
  before_action :set_schedule, :edit_schedule_path, only: [:destroy, :edit, :update]
  # protect_from_forgery except: :index

  # GET /schedules
  # GET /schedules.json
  def index
    @jobs = Job.by_company_id(current_user.company_id).published_and_closed_jobs
    if params[:by_active_job].present?
      active_job = params[:by_active_job]
    else
      active_job = @jobs.ids
    end

    @applicants = Applicant.by_job_ids(active_job)
    if params[:by_applicant].present?
      applicants = params[:by_applicant]
    else
      applicants = @applicants.ids
    end

    # @assignee = User
    if params[:by_activity].present?
      categories = params[:by_activity]
    else
      categories = @category_collection
    end
    
    @schedules = current_user.get_schedules.where("jobs.id IN (?) AND applicants.id IN (?) AND category IN (?)", active_job, applicants, categories)
    respond_to do |format|
      format.js
      format.html
    end
  end

  # GET /schedules/1
  # GET /schedules/1.json
  def show
  end

  # GET /schedules/new
  def new
    @schedule = set_applicant.schedules.new
  end

  # GET /schedules/1/edit
  def edit
  end

  # POST /schedules
  # POST /schedules.json
  def create
    @schedule = @applicant.schedules.new(schedule_params)
    respond_to do |format|
      if @schedule.save
        format.html { redirect_to @location, notice: 'Schedule was successfully created.' }
        format.json { render :show, status: :created, location: @location }
      else
        format.html { render :new }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /schedules/1
  # PATCH/PUT /schedules/1.json
  def update
    respond_to do |format|
      if @schedule.update(schedule_params)
        format.html { redirect_to @location, notice: 'Schedule was successfully updated.' }
        format.json { render :show, status: :ok, location: @location }
      else
        format.html { render :edit }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /schedules/1
  # DELETE /schedules/1.json
  def destroy
    unless @schedule.out_of_date
      @schedule.send_canceled_notify_applicant_email
    end
    @schedule.destroy
    respond_to do |format|
      format.html { redirect_to @location, notice: 'Schedule was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    
    def set_category_collection
      @category_collection = Schedule::CATEGORY
    end
    
    def set_assignee_collection
      @assignee_collection = User.by_company_id(current_user.company_id)
    end

    def set_location
      @location = company_job_applicant_path(current_user.company_id, @applicant.job_id, @applicant)
    end

    def set_applicant
      @applicant = Applicant.by_company_id(current_user.company_id).find(params[:applicant_id])
    end

    def new_schedule_path
      @url = company_job_applicant_schedules_path(current_user.company_id, @applicant.job_id, @applicant)
    end

    def edit_schedule_path
      @url = company_job_applicant_schedule_path(current_user.company_id, @applicant.job_id, @applicant, @schedule)
    end

    def set_schedule
      @schedule = Schedule.by_company_id(current_user.company_id, @applicant.id).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def schedule_params
      params.require(:schedule).permit(:start_date, :end_date, :category, :assignee_id)
    end
end
