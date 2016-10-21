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
  before_action :new_schedule_path, only: [:new, :create]
  before_action :set_schedule, :edit_schedule_path, only: [:destroy, :edit, :update]

  # GET /schedules
  # GET /schedules.json
  def index
    @schedules = current_user.get_schedules
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
    @schedule.category = @applicant.status   
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
    @schedule.destroy
    respond_to do |format|
      format.html { redirect_to @location, notice: 'Schedule was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    
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
      params.require(:schedule).permit(:start_date, :end_date, :assignee_id)
    end
end
