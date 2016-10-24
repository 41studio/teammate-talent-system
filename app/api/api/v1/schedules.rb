module API
  module V1
    class Schedules < Grape::API
      version 'v1'
      format :json
      helpers Helpers

      helpers do
        params :applicant_id do
          requires :applicant_id, type: Integer, desc: "Applicant id" 
        end

        params :schedule_id do
          requires :id, type: Integer, desc: "Schedule id" 
        end

        params :schedule do
          use :applicant_id
          requires :schedule, type: Hash do
            requires :category, type: String, values: { value: Schedule::CATEGORY, message: 'not valid' }, allow_blank: false,  desc: "Schedule category"
            requires :start_date, type: DateTime, allow_blank: false
            requires :end_date, type: DateTime, allow_blank: false
            requires :assignee_id, type: Integer, allow_blank: false
          end
        end

        def schedule_params
          ActionController::Parameters.new(params).require(:schedule).permit(:category, :start_date, :end_date, :assignee_id)
        end

        def field_on_schedule_form
          present :assignee, User.by_company_id(current_user.company_id), with: API::V1::Entities::UserEntity only: [:id, :fullname]
          present :category_collection, Schedule.new, with: API::V1::Entities::ScheduleEntity, only: [:category_valid]
        end

        def schedules
          applicant.schedules
        end

        def set_schedule
          @schedule = schedules.find(params[:id])
        end

        def applicant
          @applicant = Applicant.find(params[:applicant_id])
        end

        def error_message
          error!({ status: :error, message: @schedule.errors.full_messages.first }) if @schedule.errors.any?
        end       
      end

      resource :applicants do
        before do
          authenticate!
          applicant_valid
          unless ["all", "new", "create", ].any? { |word| request.path.include?(word) }
            set_schedule
          end
        end

        segment '/:applicant_id' do
          resource :schedules do

            desc "Schedule List", {
              :notes => <<-NOTE
              Get All Schedules by applicant_id (index)
              -----------------------------------------
              NOTE
            }
            params do
              use :pagination
            end
            get '/all' do
              begin
                present :schedules, API::V1::Entities::ScheduleEntity.represent(schedules.order('start_date DESC').page(params[:page]), only: [:id, :start_date, :end_date, :category, :sent_email_to_applicant, { applicant: [:name], assignee: [:fullname] }])
              rescue ActiveRecord::RecordNotFound
                record_not_found_message
              end          
            end

            desc "New Schedule Applicant", {
              :notes => <<-NOTE
              Schedule Applicant Form (new)
              -----------------------------
              NOTE
            }
            params do
              use :applicant_id
            end
            get '/new' do
              field_on_schedule_form
            end 

            desc "Create Schedule Applicant", {
              :notes => <<-NOTE
              Schedule Applicant create process (create)
              -------------------------------------------
              NOTE
            }
            params do
              use :schedule
            end
            post '/create' do
              @schedule = applicant.schedules.new(schedule_params)
              if @schedule.save!
                { status: :success }
              else
                error_message
              end
            end

            desc "Edit Schedule Applicant", {
              :notes => <<-NOTE
              Schedule applicant, for schedule edit form (edit)
              -------------------------------------------------
              NOTE
            }
            params do
              use :applicant_id
              use :schedule_id
            end
            get ':id/edit' do
              present :schedule, @schedule, with: API::V1::Entities::ScheduleEntity, only: [:start_date, :end_date, :category , { applicant: [:name], assignee: [:fullname] }]
              field_on_schedule_form
            end     

            desc "Update Schedule Applicant", {
              :notes => <<-NOTE
              Schedule Applicant update process (update)
              -------------------------------------------
              NOTE
            }
            params do
              use :applicant_id
              use :schedule_id
              use :schedule
            end
            put ':id/update' do
              begin
                if @schedule.update(schedule_params)
                  { status: :update_success }
                else
                  error_message
                end
              rescue ActiveRecord::RecordNotFound
                record_not_found_message
              end
            end     

            desc "Delete Schedule", {
              :notes => <<-NOTE
              Destroy Schedule (destroy)
              ---------------------------
              NOTE
            }
            params do
              use :applicant_id
              use :schedule_id
            end
            delete ':id/delete' do
              begin
                unless @schedule.out_of_date
                  @schedule.send_canceled_notify_applicant_email
                end                
                if @schedule.destroy!
                  { status: :delete_success }
                end
              rescue ActiveRecord::RecordNotFound
                record_not_found_message
              end
            end     

          end #end of schedule resource
        end #end of segment
      end #end of applicant resource
    end
  end
end





