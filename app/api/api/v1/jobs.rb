module API
  module V1
    class Jobs < Grape::API
      version 'v1'
      format :json
      before { authenticate! }
      
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

        def applicant_statuses
          ["applied", "phonescreen", "interview", "offer", "hired"]
        end

        def jobs
          current_user.company.jobs
        end

        def job
          jobs.find(params[:id]) 
        end

        def field_on_job_form
          education_list = EducationList.all
          employment_type_list = EmploymentTypeList.all
          experience_list = ExperienceList.all
          function_list = FunctionList.all
          industry_list = IndustryList.all

          present :education_list, education_list, with: API::V1::Entities::EducationList
          present :employment_type, employment_type_list, with: API::V1::Entities::EmploymentTypeList
          present :experience_list, experience_list, with: API::V1::Entities::ExperienceList
          present :function_list, function_list, with: API::V1::Entities::FunctionList
          present :industry_list, industry_list, with: API::V1::Entities::IndustryList
        end

        def error_message
          error!({ status: :error, message: job.errors.full_messages.first }) if job.errors.any?
        end        
      end

      resource :jobs do
        desc "Job List", {
          :notes => <<-NOTE
          Get All Jobs by user's company (index)
          --------------------------------------
          NOTE
        }
        get '/all' do
          begin
            data = API::V1::Entities::Job.represent(jobs, only: [:id, :job_title, :status, :created_at])
            data.as_json
          rescue ActiveRecord::RecordNotFound
            record_not_found_message
          end          
        end

        desc "Job By Id", {
          :notes => <<-NOTE
          Detail Job by job id (show)
          ---------------------------
          NOTE
        }
        params do
          use :job_id       
        end
        get ":id/detail" do
          begin
            present job, with: API::V1::Entities::Job
          rescue ActiveRecord::RecordNotFound
            record_not_found_message
          end
        end

        desc "New Job", {
          :notes => <<-NOTE
          New Job, for job form (new)
          ---------------------------
          NOTE
        }
        get '/new' do
          field_on_job_form
        end

        desc "Create Job", {
          :notes => <<-NOTE
          Create Job, save process (save)
          -------------------------------
          NOTE
        }
        post '/create' do
          job = jobs.new(job_params)
          if job.save!
            { status: :success }
          else
            error_message
          end
        end    

        desc "Edit Job", {
          :notes => <<-NOTE
          Edit Job, for job form (edit)
          ---------------------------
          NOTE
        }
        params do
          use :job_id
        end
        get ':id/edit' do
          begin
            field_on_job_form
            present :job, job, with: API::V1::Entities::Job
          rescue ActiveRecord::RecordNotFound
            record_not_found_message
          end
        end

        desc "Update Job", {
          :notes => <<-NOTE
          Update Job, update process (update)
          -----------------------------------
          NOTE
        }
        params do
          use :job_id
        end
        put ':id/update' do
          if job.update(job_params)
            { status: :update_success }
          else
            error_message
          end
        end 

        desc "Delete Job", {
          :notes => <<-NOTE
          Destroy Job (destroy)
          ---------------------
          NOTE
        }
        params do
          use :job_id
        end
        delete ':id/delete' do
          begin
            if job.destroy!
              { status: :delete_success }
            end
          rescue ActiveRecord::RecordNotFound
            record_not_found_message
          end
        end

        desc "Update Status Job By Id", {
          :notes => <<-NOTE
          Update Status Job (update)
          --------------------------
          NOTE
        }
        params do
          use :job_id
          requires :status        ,type: String, desc: "Job status"
        end
        put ':id/update_status/' do
          begin
            if job.update_attribute(:status, params[:status])
              { status: :update_success }
            else
              error_message
            end
          rescue ActiveRecord::RecordNotFound
            record_not_found_message
          end
        end

        desc "Job and applicant list", {
          :notes => <<-NOTE
          Get Job By Id with applicants group by status
          --------------------------------------------
          NOTE
        }
        params do
          use :job_id       
        end
        get ":id/applicants" do
          begin
            applicants = {}
            
            applicant_statuses.each do |status|
              applicants_with_status = job.applicants.where(status: status)
              data = API::V1::Entities::Applicant.represent(applicants_with_status, only: [:id, :name, :headline])
              applicants["total_applicants_with_status_#{status.underscore}"] = applicants_with_status.count
              applicants["applicants_with_status_#{status.underscore}"] = data.as_json
            end
          
            applicants

          rescue ActiveRecord::RecordNotFound
            record_not_found_message
           end
        end

        desc "Job List", {
          :notes => <<-NOTE
          Get All Jobs by user's company
          ------------------------------
          NOTE
        }
        get '/all_jobs' do
          {jobs: [API::V1::Entities::Job.represent(jobs, only: [:id, :job_title, :status, :created_at])]}
        end

        desc "Job List with user profile", {
          :notes => <<-NOTE
          Get All Jobs by user's company
          ------------------------------
          NOTE
        }
        get '/all_jobs_with_user' do
          {user: current_user.user_api(current_user), jobs: [current_user.company.jobs]}
        end
      end #end resource
    end
  end
end
