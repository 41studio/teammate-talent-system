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
  before_action :get_applicant, only: [:new, :create]
  before_action :set_schedule, only: [:new, :create]
  before_action :get_schedule, only: [:show, :destroy, :edit, :update]
  before_action :set_applicant, only: [:edit, :update]
  before_action :collection

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
  end

  # GET /schedules/1/edit
  def edit
  end

  # POST /schedules
  # POST /schedules.json
  def create

    @schedule = @applicant.schedules.new(schedule_params)
    @schedule.notify_applicant_flag = "true"
    
    respond_to do |format|
      if @schedule.save
        format.html { redirect_to company_job_applicant_path(current_user.company_id, @applicant.job_id, @applicant), notice: 'Schedule was successfully created.' }
        format.json { render :show, status: :created, location: @schedule }
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
        format.html { redirect_to company_job_applicant_path(current_user.company_id, @applicant.job_id, @applicant), notice: 'Schedule was successfully updated.' }
        format.json { render :show, status: :ok, location: @schedule }
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
      format.html { redirect_to schedules_url, notice: 'Schedule was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_applicant
      @applicant = @schedule.applicant
    end

    def get_applicant
      @applicant = Applicant.find(params[:id])
    end

    def set_schedule
      @schedule = @applicant.schedules.build
    end

    def get_schedule
      @schedule = Schedule.find(params[:id])
    end

    def collection
      @collection = [["Interview", "Interview"], ["Offer", "Offer"], ["Hired", "Hired"]].collect {|i| [i[1], i[1]]}
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def schedule_params
      params.require(:schedule).permit(:date, :category)
    end
end
