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
      end

      resource :jobs do
        desc "Job List with user profile", {
          :notes => <<-NOTE
          Get All Jobs by user's company
          ------------------------------
          NOTE
        }
        get '/all' do
          user_jobs = {user: current_user.user_api(current_user), jobs: [current_user.company.jobs]}
        end

        desc "Job By Id", {
          :notes => <<-NOTE
          Get Job By Id with applicant group by status
          --------------------------------------------
          NOTE
        }
        params do
          use :job_id       
        end
        get ":id/applicants" do
          begin
            job = Job.find(params[:id])
            jobs = {}
            
            applicant_statuses.each do |status|
              jobs_with_status = job.applicants.where(status: status).as_json
              jobs["total_jobs_with_status_#{status.underscore}"] = jobs_with_status.count
              jobs["jobs_with_status_#{status.underscore}"] = jobs_with_status
            end
          
            jobs

          rescue ActiveRecord::RecordNotFound
            error!({status: :not_found}, 404)
           end
        end

      end #end resource
    end
  end
end
