module API
  module V1
    class Jobs < Grape::API
      version 'v1'
      format :json

      helpers do
        params :job_id do
          requires :id, type: Integer, desc: "Job id" 
        end
      end

      #index (all), show
      resource :jobs do
        desc "Job List with user", {
          :notes => <<-NOTE
          Get All Jobs by user's company
          --------------------
          NOTE
        }
        get do
          authenticate!
          user_jobs = {user: current_user, jobs: [current_user.company.jobs]}
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

        # desc "Job By Id", {
        #   :notes => <<-NOTE
        #   Get Job By Id
        #   --------------------
        #   NOTE
        # }
        # params do
        #   use :job_id       
        # end
        # get ":id" do
        #   begin
        #     _job = Job.find(params[:id])
        #     job = _job.as_json

        #     applicant_statuses.each do |status|
        #       job["total_with_status_#{status}".to_s] = _job.applicants.where(status: "#{status}").count
        #     end

        #     return job

        #   rescue ActiveRecord::RecordNotFound
        #     error!({status: :not_found}, 404)
        #    end
        # end

        # desc "Education_lists By Job Id", {
        #   :notes => <<-NOTE
        #   Get Education_lists By Job Id
        #   -----------------------------
        #   NOTE
        # }
        # params do
        #   use :education_id       
        # end
        # get "/education_list/:id" do
        #   begin
        #     EducationList.select(:name).find(params[:id])
        #   rescue ActiveRecord::RecordNotFound
        #     error!({status: :not_found}, 404)
        #    end
        # end


      end #end resource
    end
  end
end
