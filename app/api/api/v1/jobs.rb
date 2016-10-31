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
            :job_title, :departement, :job_code, :country, :state, :city, 
            :zip_code, :min_salary, :max_salary, :curency, :job_description, 
            :job_requirement, :benefits, :experience_list_id, :function_list_id,
            :employment_type_list_id, :industry_list_id, :education_list_id, 
            :job_search_keyword
          )
        end

        def set_job
          @job = @jobs.find(params[:id]) 
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
          present :jobs, jobs.page(page), with: API::V1::Entities::JobEntity, only: [:id, :job_title, :country, :state, :city, {company: [:photo_company]}]
        end

        def error_message
          error!({ status: :error, message: @job.errors.full_messages.first }) if @job.errors.any?
        end        
      end

      resource :jobs do
        before do
          unless request.path.include?("jobs/search")
            authenticate!
            set_jobs
            unless request.path.include?("jobs/all")
              set_job
            end
          end
        end

        desc "Job List" do
          detail ' : job list in company (show)'
          named 'jobs'
          headers token: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        params do
          use :pagination
        end
        get '/all' do
          begin
            present :jobs, @jobs.order(status: :desc, created_at: :desc).page(params[:page]), with: API::V1::Entities::JobEntity, only: [:id, :job_title, :status, :created_at]
          rescue ActiveRecord::RecordNotFound
            record_not_found_message
          end          
        end

        desc "Job Detail" do
          detail ' : show job by id'
          named 'jobs'
          headers token: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        params do
          use :job_id       
        end
        get ":id/detail" do
          begin
            present job, with: API::V1::Entities::JobEntity, except: [:company, :updated_at , { education_list: [:id], employment_type_list: [:id], experience_list: [:id], function_list: [:id], industry_list: [:id] }]
          rescue ActiveRecord::RecordNotFound
            record_not_found_message
          end
        end

        desc "New Job" do
          detail ' : create job form (new)'
          named 'jobs'
          headers token: {
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
          headers token: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        post '/create' do
          @job = jobs.new(job_params)
          if @job.save!
            { status: :success }
          else
            error_message
          end
        end    

        desc "Edit Job" do
          detail ' : edit job form (edit)'
          named 'jobs'
          headers token: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        params do
          use :job_id
        end
        get ':id/edit' do
          begin
            present :job, @job, with: API::V1::Entities::JobEntity
            field_on_job_form
          rescue ActiveRecord::RecordNotFound
            record_not_found_message
          end
        end

        desc "Update Job" do
          detail ' : update process (update)'
          named 'jobs'
          params API::V1::Entities::JobEntity.documentation
          headers token: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        params do
          use :job_id
        end
        put ':id/update' do
          if @job.update(job_params)
            { status: "Job updated" }
          else
            error_message
          end
        end 

        desc "Delete Job" do
          detail ' : destroy job process (destroy)'
          named 'jobs'
          headers token: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        params do
          use :job_id
        end
        delete ':id/delete' do
          begin
            if @job.destroy!
              { status: "Job deleted" }
            end
          rescue ActiveRecord::RecordNotFound
            record_not_found_message
          end
        end

        desc "Edit Job's Status" do
          detail " : edit job's status form (edit)"
          named 'jobs'
          headers token: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        params do
          use :job_id
        end
        get ':id/edit_status' do
          present Job::STATUSES, root: 'job_statuses'
          present :job, @job, with: API::V1::Entities::JobEntity, only: [:status]
        end

        desc "Update Job Status" do
          detail " : update job's status process (update)"
          named 'jobs'
          headers token: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        params do
          use :job_id
          requires :status ,type: String, values: { value: Job::STATUSES.map{|s| s.to_s}, message: 'not valid' }, desc: "Job status"
        end
        put ':id/update_status/' do
          begin
            if @job.update_attribute(:status, params[:status])
              { status: :update_success }
            else
              error_message
            end
          rescue ActiveRecord::RecordNotFound
            record_not_found_message
          end
        end

        desc "Total of applicant" do
          detail ' : per status'
          named 'jobs'
          headers token: {
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
          headers token: {
                  description: 'Validates user identity by token',
                  required: true
                }
        end
        params do
          use :job_id       
          use :pagination
          requires :status        ,type: String, desc: "Applicants status", allow_blank: false
        end
        get ":id/applicants" do
          begin
            applicants_with_status = @job.applicants.where(status: params[:status])
            present :applicants, applicants_with_status.page(params[:page]), with: API::V1::Entities::ApplicantEntity, except: [ { educations: [:id], experiences: [:id] }]
          rescue ActiveRecord::RecordNotFound
            record_not_found_message
           end
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
            optional :job_title, type: String, default: 'asc', values: { value: ['asc','desc'], message: 'not valid' }, desc: "Sort by job title ASC / DESC"
            optional :created_at, type: String, default: 'desc', values: { value: ['asc','desc'], message: 'not valid' },  desc: "Sort by created date ASC / DESC"
          end
        end
        get "/search" do
          @search = Job.search(params[:q])
          params[:sort_by].present? ? @search.sorts = params[:sort_by].map{|k,v| "#{k.to_s} #{v.to_s}"} : @search.sorts = ['job_title asc', 'created_at desc']
          @jobs = @search.result.published_jobs
          @jobs ? search_jobs(@jobs, params[:page]) : { status: "No Jobs Related"}
        end
      end #end resource
    end
  end
end