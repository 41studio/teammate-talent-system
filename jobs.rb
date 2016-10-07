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