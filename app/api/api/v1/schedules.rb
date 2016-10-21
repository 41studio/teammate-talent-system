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

        def schedule_params
          ActionController::Parameters.new(params).require(:schedule).permit(:start_date, :end_date, :category)
        end

        def field_on_schedule_form
          present :users, current_user.company.users, with: API::V1::Entities::User, only: [:id, :fullname]
        end

        def schedules
          applicant.schedules
        end

        def schedule
          schedules.find(params[:id])
        end

        def applicant
          Applicant.find(params[:applicant_id])
        end
      end

      resource :applicants do
        before do
          authenticate!
          applicant_valid
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
            get do
              begin
                API::V1::Entities::Schedule.represent(schedules.page(params[:page]), only: [:id, :start_date, :end_date, :category, :sent_email_to_applicant, { applicant: [:name], assignee: [:fullname] }])
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
            get 'new' do
              field_on_schedule_form
            end 

            desc "Create Schedule Applicant", {
              :notes => <<-NOTE
              Schedule Applicant create process (create)
              -------------------------------------------
              NOTE
            }
            params do
              use :applicant_id
              requires :start_date, type: DateTime, allow_blank: false
              requires :end_date, type: DateTime, allow_blank: false
              requires :category, type: DateTime, allow_blank: false
            end
            post 'create' do
              schedule = applicant.schedules.new(schedule_params)
              schedule.category = applicant.status
              if schedule.save!
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
            get ':id/edit' do
              present :schedule, schedule, with: API::V1::Entities::Schedule, only: [:start_date, :end_date, :category , { applicant: [:name], assignee: [:fullname] }]
              field_on_schedule_form
            end     

            put ':id/update' do
              
            end     

            delete ':id/delete' do
              
            end     

          end #end of schedule resource
        end #end of segment
      end #end of applicant resource
    end
  end
end





