module API
  module V1
    class Schedules < Grape::API
      version 'v1'
      format :json
      helpers Helpers

      helpers do
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
          set_company
          present :assignee, User.by_company_id(@current_company), with: API::V1::Entities::UserEntity, only: [:id, :fullname]
          present :category_collection, Schedule.new, with: API::V1::Entities::ScheduleEntity, only: [:category_valid]
        end

        def schedules
          @applicant.schedules
        end

        def set_applicant
          begin
            @applicant = Applicant.find(params[:applicant_id])
          rescue ActiveRecord::RecordNotFound
            error!("Applicant id is invalid, id does not have a valid value", 400)
          end
        end

        def set_schedule
          begin
            @schedule = schedules.find(params[:id])
          rescue ActiveRecord::RecordNotFound
            error!("Schedule id is invalid, id does not have a valid value", 400)
          end
        end

        def error_message
          error!({ status: :error, message: @schedule.errors.full_messages.first }, 400) if @schedule.errors.any?
        end       
      end

      resource :applicants do
        segment '/:applicant_id' do
          resource :schedules do
            before do
              authenticate!
              find_applicant
              applicant_valid
              unless ["all", "new", "create", ].any? { |word| request.path.include?(word) }
                set_schedule
              end
            end

            desc "Schedule List" do
              detail ' : schedules list on applicant'
              named 'schedules'
              headers X_Auth_Token: {
                      description: 'Validates user identity by token',
                      required: true
                    }
            end
            params do
              use :pagination
            end
            get '/all' , failure: [
              { code: 200, message: 'OK' },
              { code: 400, message: "id is invalid, id does not have a valid value" },
              { code: 401, message: "Invalid or expired token"},
            ] do
                present :schedules, API::V1::Entities::ScheduleEntity.represent(schedules.order('start_date DESC').page(params[:page]), only: [:id, :start_date, :end_date, :category, { assignee: [:fullname] }])
                # present :schedules, API::V1::Entities::ScheduleEntity.represent(schedules.order('start_date DESC').page(params[:page]), only: [:id, :start_date, :end_date, :category, :sent_email_to_applicant, { applicant: [:name], assignee: [:fullname] }])
            end

            desc "New Applicant's Schedule " do
              detail " : applicant's schedule form (new)"
              named 'schedules'
              headers X_Auth_Token: {
                      description: 'Validates user identity by token',
                      required: true
                    }
            end
            params do
              use :applicant_id
            end
            get '/new' do
              field_on_schedule_form
            end 

            desc "Create Schedule Applicant" do
              detail ' : create process (save)'
              params API::V1::Entities::ScheduleEntity.documentation
              named 'schedules'
              headers X_Auth_Token: {
                      description: 'Validates user identity by token',
                      required: true
                    }
            end
            params do
              use :schedule
            end
            post '/create' , failure: [
              { code: 201, message: 'Created' },
              { code: 400, message: "parameter is invalid" },
              { code: 401, message: "Invalid or expired token"},
            ] do
              @schedule = @applicant.schedules.new(schedule_params)
              begin
                if @schedule.save!
                  @schedule
                else
                  error_message
                end
              rescue ActiveRecord::RecordInvalid
                error_message
              end 
            end

            desc "Edit Schedule" do
              detail ' : schedule edit form (edit)'
              named 'schedules'
              headers X_Auth_Token: {
                      description: 'Validates user identity by token',
                      required: true
                    }
            end
            params do
              use :applicant_id
              use :schedule_id
            end
            get ':id/edit' , failure: [
              { code: 200, message: 'OK' },
              { code: 400, message: "id is invalid, id does not have a valid value" },
              { code: 401, message: "Invalid or expired token"},
            ] do
              present :schedule, @schedule, with: API::V1::Entities::ScheduleEntity, only: [:start_date, :end_date, :category , { applicant: [:name], assignee: [:fullname] }]
              field_on_schedule_form
            end     

            desc "Update Schedule" do
              detail ' : update process (update)'
              # params API::V1::Entities::ScheduleEntity.documentation
              named 'schedules'
              headers X_Auth_Token: {
                      description: 'Validates user identity by token',
                      required: true
                    }
            end
            params do
              use :applicant_id
              use :schedule_id
              use :schedule
            end
            put ':id/update' , failure: [
              { code: 200, message: 'OK' },
              { code: 400, message: "id is invalid, id does not have a valid value" },
              { code: 401, message: "Invalid or expired token"},
            ] do
              begin
                if @schedule.update(schedule_params)
                  { status: "Schedule updated" }
                  @schedule
                else
                  error_message
                end
              rescue ActiveRecord::RecordInvalid
                error_message
              end
            end     

            desc "Delete Schedule" do
              detail ' : destroy process (destroy)'
              named 'schedules'
              headers X_Auth_Token: {
                      description: 'Validates user identity by token',
                      required: true
                    }
            end
            params do
              use :applicant_id
              use :schedule_id
            end
            delete ':id/delete' , failure: [
              { code: 200, message: 'OK' },
              { code: 400, message: "id is invalid, id does not have a valid value" },
              { code: 401, message: "Invalid or expired token"},
            ] do
              unless @schedule.out_of_date
                @schedule.send_canceled_notify_applicant_email
              end                
              if @schedule.destroy!
                { status: "Schedule deleted" }
                @schedule
              end
            end     

          end #end of schedule resource
        end #end of segment
      end #end of applicant resource
    end
  end
end





