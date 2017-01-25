module API
  module V1
    class Companies < Grape::API
      version 'v1', using: :path, vendor: 'teamhire'
      # curl -X GET --header 'Accept: application/json' --header 'token: MzZs1v5js-Fw961nrWvh' 'http://localhost:3000/api/companies/detail'
      # curl -X GET --header 'Accept: application/json' --header 'token: MzZs1v5js-Fw961nrWvh' 'http://localhost:3000/api/v1/companies/detail'
      format :json 
      helpers Helpers

      helpers do
        params :company do
          requires :company_name,    type: String, allow_blank: false
          requires :company_website, type: String, allow_blank: false
          requires :company_email,   type: String, regexp: /.+@.+/,  allow_blank: false
          requires :company_phone,   type: String, regexp: /^[0-9]/, allow_blank: false
          requires :industry,        type: String, allow_blank: false
        end

        def company_params
          company_param = ActionController::Parameters.new(params).require(:company).permit(:company_name, :company_website, :company_email, :company_phone, :industry, photo_company: [:filename, :type, :name, :tempfile, :head])
          company_param["photo_company"] = ActionDispatch::Http::UploadedFile.new(params.company.photo_company) if params.company.photo_company.present? 
          company_param
        end

        params :company_id do
          requires :id, type: Integer, desc: "Company id" 
        end

        def find_company
          begin
            @company = Company.find(params[:id])
          rescue ActiveRecord::RecordNotFound
            error!("id is invalid, id does not have a valid value", 400)
          end
        end

        def find_job
          begin
            find_company
            @job = @company.jobs.find(params[:job_id])
          rescue ActiveRecord::RecordNotFound
            error!("id is invalid, id does not have a valid value", 400)
          end
        end

        def invitation_params
          ActionController::Parameters.new(params).permit(:email)
        end

        def field_on_company_form
          industry_list = IndustryList.all
          present :industry_list, industry_list, with: API::V1::Entities::IndustryListEntity, only: [:industry]
        end     

        def error_message
          error!({ status: :error, message: @company.errors.full_messages.first }, 400) if @company.errors.any?
        end
      end      

      resource :companies do
        before do
          unless request.path.include?("/public")
            authenticate!
            set_company
          else
            find_company
          end
        end

        desc "New Company" do
          detail ' : create company form (new)'
          named 'companies'
          headers X_Auth_Token: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        get '/new' do
          field_on_company_form
        end

        desc "Create Company" do
          detail ' : create process (save)'
          params API::V1::Entities::CompanyEntity.documentation
          named 'companies'
          headers X_Auth_Token: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        params do
          requires :company, type: Hash do
            use :company
            requires :photo_company, type: File, allow_blank: false
          end
        end
        post '/create' , failure: [
          { code: 201, message: 'Created' },
          { code: 400, message: "parameter is invalid" },
          { code: 401, message: "Invalid or expired token"},
        ] do
          if @company
            { status: "You are belongs to one company" }
          else
            @company = Company.create(company_params)
            begin
              if @company.save!
                current_user.update_attribute(:company_id, @company.id)
                { status: "Company created" }
                @company
              else
                error_message
              end
            rescue ActiveRecord::RecordInvalid
              error_message
            end
          end
        end  

        desc "Company detail public" do
          detail ' : show company detail for public'
          named 'companies'
        end
        params do
          use :company_id
        end
        get ':id/detail/public' , failure: [
          { code: 200, message: 'OK' },
          { code: 400, message: "id is invalid, id does not have a valid value" },
        ] do
          API::V1::Entities::CompanyEntity.represent(@company)
        end

        desc "Company detail" do
          detail ' : show company'
          named 'companies'
          headers X_Auth_Token: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        get '/detail' , failure: [
          { code: 200, message: 'OK' },
          { code: 401, message: "Invalid or expired token"},
        ] do
            @company.present? ? API::V1::Entities::CompanyEntity.represent(@company) : "Create company profile first"
        end

        desc "Job list public" do
          detail ' : show job list for public'
          named 'companies'
        end
        params do
          use :company_id
        end        
        get ':id/jobs/public' , failure: [
          { code: 200, message: 'OK' },
          { code: 400, message: "parameter is invalid" },
        ] do
          present @company.jobs, with: API::V1::Entities::JobEntity, except: [:company, :updated_at , { education_list: [:id], employment_type_list: [:id], experience_list: [:id], function_list: [:id], industry_list: [:id] }]
        end

        desc "Job list" do
          detail ' : show job list'
          named 'companies'
          headers X_Auth_Token: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        get '/jobs' do
          begin
            present @company.jobs, with: API::V1::Entities::JobEntity, except: [:company, :updated_at , { education_list: [:id], employment_type_list: [:id], experience_list: [:id], function_list: [:id], industry_list: [:id] }]
          rescue ActiveRecord::RecordNotFound
            record_not_found_message
           end
        end

        desc "Job detail public" do
          detail ' : show job detail for public'
          named 'companies'
        end
        params do
          requires :job_id, type: Integer, desc: "Job id" 
        end
        get '/jobs/:job_id' , failure: [
          { code: 200, message: 'OK' },
          { code: 400, message: "parameter is invalid" },
        ] do
          find_job
          present @job, with: API::V1::Entities::JobEntity, except: [:company, :updated_at , { education_list: [:id], employment_type_list: [:id], experience_list: [:id], function_list: [:id], industry_list: [:id] }]
        end

        desc "Edit Company" do
          detail ' : edit company form (edit)'
          params API::V1::Entities::CompanyEntity.documentation
          named 'companies'
          headers X_Auth_Token: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        get '/edit' , failure: [
          { code: 200, message: 'OK' },
          { code: 400, message: "parameter is invalid" },
          { code: 401, message: "Invalid or expired token"},
        ] do
          field_on_company_form
          present :company, @company, with: API::V1::Entities::CompanyEntity
        end

        desc "Update Company" do
          detail ' : update company process (update)'
          params API::V1::Entities::CompanyEntity.documentation
          named 'companies'
          headers X_Auth_Token: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        params do
          requires :company, type: Hash do
            use :company
            optional :photo_company, type: File
          end
        end
        put '/update' , failure: [
          { code: 200, message: 'OK' },
          { code: 400, message: "parameter is invalid" },
          { code: 401, message: "Invalid or expired token"},
        ] do
          begin
            if @company.update(company_params)
              { status: "Company updated" }
              @company
            else
              error_message
            end
          rescue ActiveRecord::RecordInvalid
            error_message
          end
        end 

        desc "User List" do
          detail ' : users list in company (show)'
          named 'companies'
          headers X_Auth_Token: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        params do
          use :pagination
        end
        get '/users' , failure: [
          { code: 200, message: 'OK' },
          { code: 401, message: "Invalid or expired token"},
        ] do
          users = User.by_company_id(@company)
          present :users, users.page(params[:page]), with: API::V1::Entities::UserEntity, only: [:id, :fullname]
        end

        desc "Invite Personel" do
          detail ' : send invitation email'
          named 'companies'
          headers X_Auth_Token: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        params do
          requires :email, type: String, regexp: /.+@.+/, allow_blank: false, desc: "Personnel email"
        end
        post '/invite_personnel' do
          if User.find_by(email: invitation_params[:email]).present?
            { status: "This user has belongs to one company" }
          else
            if User.invite!({email: invitation_params[:email], company_id: @company}, current_user)
              { status: "User Invited. Invitation email has sent." }
            else
              error_message
            end
          end
        end        

        desc "Company Agenda" do
          detail ' : agenda list in company (show)'
          params API::V1::Entities::ScheduleEntity.documentation
          named 'schedules'
          headers X_Auth_Token: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        params do
          use :pagination
        end
        get '/agenda' , failure: [
          { code: 200, message: 'OK' },
          { code: 401, message: "Invalid or expired token"},
        ] do
          applicants = @company.applicants.map(&:id)
          schedules  = Schedule.where("schedules.id IN (?)", applicants)
          present :agendas, API::V1::Entities::ScheduleEntity.represent(schedules.order('start_date DESC').page(params[:page]), only: [:id, :start_date, :end_date, :category, :sent_email_to_applicant, { applicant: [:id, :name], assignee: [:fullname] }])
        end        

        desc "Applicant Report Filter Form" do
          detail ' : filter for form field'
          params API::V1::Entities::ScheduleEntity.documentation
          named 'schedules'
          headers X_Auth_Token: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        get '/report/filter' do
          field_on_filter_form
        end  

        desc "Applicant Report" do
          detail ' : filter process'
          params API::V1::Entities::ScheduleEntity.documentation
          named 'schedules'
          headers X_Auth_Token: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        params do
          use :pagination
          use :applicant_filter
        end
        get '/report' , failure: [
          { code: 200, message: 'OK' },
          { code: 400, message: "parameter is invalid" },
          { code: 401, message: "Invalid or expired token"},
        ] do
          set_applicant_filter_params
          @report_filter = Applicant.join_job.filter_report_applicant(@company, @job, @stage, @gender).group(@period).count
          @report_filter.present? ? @report_filter : { status: "No report for this condition"}
        end        

      end #end resource
    end
  end
end