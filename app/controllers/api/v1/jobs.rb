module API
  module V1
    class Jobs < Grape::API
      version 'v1' 
      format :json 
      helpers Helpers

      helpers do
        params :job_id do
          requires :id, type: Integer, desc: "Job id" 
        end

        def job_params
          ActionController::Parameters.new(params).require(:job).permit(
            :title, :departement, :code, :country, :state, :city, 
            :zip_code, :min_salary, :max_salary, :curency, :description, 
            :requirement, :benefits, :experience_list_id, :function_list_id,
            :employment_type_list_id, :industry_list_id, :education_list_id, 
            :search_keyword
          )
        end

        def set_job
          begin
            @job = @jobs.find(params[:id])
          rescue ActiveRecord::RecordNotFound
            error!("id is invalid, id does not have a valid value", 400)
          end
        end
        
        def field_on_job_form
          education_list = EducationList.all
          employment_type_list = EmploymentTypeList.all
          experience_list = ExperienceList.all
          function_list = FunctionList.all
          industry_list = IndustryList.all

          present :education_list, education_list, with: API::V1::Entities::EducationListEntity
          present :employment_type, employment_type_list, with: API::V1::Entities::EmploymentTypeListEntity
          present :experience_list, experience_list, with: API::V1::Entities::ExperienceListEntity
          present :function_list, function_list, with: API::V1::Entities::FunctionListEntity
          present :industry_list, industry_list, with: API::V1::Entities::IndustryListEntity
        end

        def search_jobs(jobs, page)
          present :jobs, jobs.page(page), with: API::V1::Entities::JobEntity, only: [:id, :title, :country, :state, :city, {company: [:photo_company]}]
        end

        def error_message
          error!({ status: :error, message: @job.errors.full_messages.first }, 400) if @job.errors.any?
        end        
      end

      resource :jobs do
        before do
          unless request.path.include?("jobs/search")
            authenticate!
            set_jobs
            unless ["all", "new", "create"].any? { |word| request.path.include?(word) }
              set_job
            end
          end
        end

        desc "Job List" do
          detail ' : job list in company (show)'
          named 'jobs'
          headers X_Auth_Token: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        params do
          use :pagination
        end
        get '/all' do
          begin
            present :jobs, @jobs.order(status: :desc, created_at: :desc).page(params[:page]), with: API::V1::Entities::JobEntity, only: [:id, :title, :status, :created_at]
          rescue ActiveRecord::RecordNotFound
            record_not_found_message
          end          
        end

        desc "Job Detail" do
          detail ' : show job by id'
          named 'jobs'
          headers X_Auth_Token: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        params do
          use :job_id       
        end
        get ":id/detail" , failure: [
          { code: 200, message: 'OK' },
          { code: 400, message: "parameter is invalid" },
          { code: 401, message: "Invalid or expired token"},
        ] do
          present job, with: API::V1::Entities::JobEntity, except: [:company, :updated_at , { education_list: [:id], employment_type_list: [:id], experience_list: [:id], function_list: [:id], industry_list: [:id] }]
        end

        desc "New Job" do
          detail ' : create job form (new)'
          named 'jobs'
          headers X_Auth_Token: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        get '/new' do
          field_on_job_form
        end

        desc "Create Job" do
          detail ' : save job process (save)'
          named 'jobs'
          params API::V1::Entities::JobEntity.documentation
          headers X_Auth_Token: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        post '/create' , failure: [
          { code: 201, message: 'Created' },
          { code: 400, message: "parameter is invalid" },
          { code: 401, message: "Invalid or expired token"},
        ] do
          @job = @jobs.new(job_params)
          begin
            if @job.save!
              { status: :success }
              @job
            else
              error_message
            end
          rescue ActiveRecord::RecordInvalid
            error_message
          end
        end    

        desc "Edit Job" do
          detail ' : edit job form (edit)'
          named 'jobs'
          headers X_Auth_Token: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        params do
          use :job_id
        end
        get ':id/edit' , failure: [
          { code: 200, message: 'OK' },
          { code: 400, message: "parameter is invalid" },
          { code: 401, message: "Invalid or expired token"},
        ] do
          present :job, @job, with: API::V1::Entities::JobEntity
          field_on_job_form
        end

        desc "Update Job" do
          detail ' : update process (update)'
          named 'jobs'
          params API::V1::Entities::JobEntity.documentation
          headers X_Auth_Token: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        params do
          use :job_id
        end
        put ':id/update' , failure: [
          { code: 200, message: 'OK' },
          { code: 400, message: "parameter is invalid" },
          { code: 401, message: "Invalid or expired token"},
        ] do
          begin
            if @job.update(job_params)
              { status: "Job updated" }
              @job
            else
              error_message
            end
          rescue ActiveRecord::RecordInvalid
            error_message
          end          
        end 

        desc "Delete Job" do
          detail ' : destroy job process (destroy)'
          named 'jobs'
          headers X_Auth_Token: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        params do
          use :job_id
        end
        delete ':id/delete' , failure: [
          { code: 200, message: 'OK' },
          { code: 400, message: "id is invalid, id does not have a valid value" },
          { code: 401, message: "Invalid or expired token"},
        ] do
          if @job.destroy!
            { status: "Job deleted" }
            @job
          end
        end

        desc "Edit Job's Status" do
          detail " : edit job's status form (edit)"
          named 'jobs'
          headers X_Auth_Token: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        params do
          use :job_id
        end
        get ':id/edit_status' , failure: [
          { code: 200, message: 'OK' },
          { code: 400, message: "parameter is invalid" },
          { code: 401, message: "Invalid or expired token"},
        ] do
          present Job::STATUSES, root: 'job_statuses'
          present :job, @job, with: API::V1::Entities::JobEntity, only: [:status]
        end

        desc "Update Job Status" do
          detail " : update job's status process (update)"
          named 'jobs'
          headers X_Auth_Token: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        params do
          use :job_id
          requires :status ,type: String, values: { value: Job::STATUSES.map{|s| s.to_s}, message: 'not valid' }, desc: "Job status"
        end
        put ':id/update_status/', failure: [
          { code: 200, message: 'OK' },
          { code: 400, message: "parameter is invalid" },
          { code: 401, message: "Invalid or expired token"},
        ] do
          begin
            if @job.update_attribute(:status, params[:status])
              { status: :update_success }
              @job
            else
              error_message
            end
          rescue ActiveRecord::RecordInvalid
            error_message
          end
        end

        desc "Total of applicant" do
          detail ' : per status'
          named 'jobs'
          headers X_Auth_Token: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        params do
          use :job_id       
        end
        get ":id/applicant_total_by_status" do
          begin
            statuses = {}
            Applicant::STATUSES.each do |status, val|
              statuses[status.to_s.underscore] = @job.applicants.where(status: status).size.to_s
            end
            # present statuses, root: 'applicant_statuses'
            # present :applicants, job.applicants.where(status: "applied"), with: API::V1::Entities::ApplicantEntity
            statuses
          rescue ActiveRecord::RecordNotFound
            record_not_found_message
          end
        end

        desc "Applicant list by status" do
          detail ' : applicants group by status'
          named 'jobs'
          headers XAuthToken: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        params do
          use :job_id       
          use :pagination
          optional :status        ,type: String, desc: "Applicants status", allow_blank: false
        end
        get ":id/applicants", failure: [
          { code: 200, message: 'OK' },
          { code: 400, message: "id is invalid, id does not have a valid value" },
          { code: 401, message: "Invalid or expired token"},
        ] do
            # applicants = params[:status].present? ? @job.applicants.where(status: params[:status]) : @job.applicants
            # present :applicants, applicants.page(params[:page]), with: API::V1::Entities::ApplicantEntity, except: [ { educations: [:id], experiences: [:id] }]
          
            applicants = params[:status].present? ? @job.applicants.where(status: params[:status]) : @job.applicants
            result = {'Applicants' => []}

            applicants.page(params[:page]).each do |applicant|
              applicant = API::V1::Entities::ApplicantEntity.represent(applicant, except: [ { educations: [:id], experiences: [:id] }]).as_json
              applicant['user_avatar'] = API::V1::Entities::UserEntity.represent(current_user, only: [:avatar]).as_json
              result['Applicants'] << applicant
            end

            result
        end

        desc "Search Job" do
          detail ' : by search keywords'
          named 'jobs'
        end
        params do
          use :pagination
          optional :q, type: Hash do
            optional :keyword_cont, type: String, desc: "Name or job keyword"
            optional :city_cont, type: String, desc: "Company city"
            optional :company_cont, type: String, desc: "Company name"
            optional :industry_cont, type: String, desc: "Industry name"
            optional :max_salary_lteq, type: Integer, desc: "Max salary"
            optional :min_salary_gteq, type: Integer, desc: "Min salary"
          end
          optional :sort_by, type: Hash do
            optional :title, type: String, default: 'asc', values: { value: ['asc','desc'], message: 'not valid' }, desc: "Sort by job title ASC / DESC"
            optional :created_at, type: String, default: 'desc', values: { value: ['asc','desc'], message: 'not valid' },  desc: "Sort by created date ASC / DESC"
          end
        end
        get "/search", failure: [
          { code: 200, message: 'OK' },
          { code: 400, message: "parameter is invalid" },
        ] do
          @search = Job.search(params[:q])
          params[:sort_by].present? ? @search.sorts = params[:sort_by].map{|k,v| "#{k.to_s} #{v.to_s}"} : @search.sorts = ['title asc', 'created_at desc']
          @jobs = @search.result.published_jobs
          @jobs ? search_jobs(@jobs, params[:page]) : { status: "No Jobs Related"}
        end
      end #end resource
    end
  end
end