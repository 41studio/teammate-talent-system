module API
  module V1
	module Helpers
    extend Grape::API::Helpers
    
    def current_user
      token = ApiKey.find_by(access_token: headers['X-Auth-Token'])
      if token && !token.expired?
        User.find(token.user_id)
      else
        false
      end
    end

    def set_company
      @company = current_user.company
    end

    def authenticate!
      error!("Invalid or expired token", 401) unless current_user
    end

    def applicant_valid
      error!("Invalid or expired token", 401) unless @applicant.job.company.users.include?current_user
    end
  
    def field_on_filter_form
      set_jobs
      present :by_period, Applicant::PERIOD, root: 'period'
      present :by_stages, Applicant.applicant_statuses, root: 'stage'
      present :by_jobs, @jobs.order(created_at: :desc, job_title: :asc), with: API::V1::Entities::JobEntity, only: [:id, :job_title]
      present :by_consideration, ['qualified','disqualified'], root: 'consideration'
      present :by_gender, ['Male','Female'], root: 'gender'
    end    

    def set_jobs
      set_company
      @jobs = @company.jobs
    end

    def set_applicant
      begin
        @applicant = Applicant.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        error!("id is invalid, id does not have a valid value", 400)
      end                
    end

    def find_applicant
      begin
        @applicant = Applicant.find(params[:applicant_id])
      rescue ActiveRecord::RecordNotFound
        error!("Applicant id is invalid, id does not have a valid value", 400)
      end
    end

		def record_not_found_message
			error!({status: :not_found}, 404)
		end

    Grape::Entity.format_with :timestamp do |date|
      date.strftime('%m/%d/%Y - %l:%M %p')
    end

    params :applicant_id do
      requires :applicant_id, type: Integer, desc: "Applicant id" 
    end

    params :pagination do
      optional :pages        ,type: Integer, desc: "Page number for pagination"
      optional :per_page     ,type: Integer, desc: "Total per page for pagination"
    end

    params :applicant_filter do
      optional :by_period, type: Hash do
        optional :period,  type: String, values: { value: Applicant::PERIOD, message: 'not valid' }, desc: "Per Period"
      end
      optional :by_stages, type: Hash do
        optional :stage,   type: Array[String], values: { value: Applicant.applicant_statuses, message: 'not valid' }, desc: "Applicant status" 
      end
      optional :by_jobs, type: Hash do
        optional :job,   type: Array[Integer], desc: "Job ids" 
      end
      optional :by_consideration, type: Hash do
        optional :consideration, type: Array[String], values: { value: ['qualified','disqualified'], message: 'not valid'}, desc: "Applicant consideration" 
      end
      optional :by_gender, type: Hash do
        optional :gender,  type: Array[String], values: { value: ['Male','Female'], message: 'not valid'}, desc: "Applicant gender" 
      end          
    end

    def set_applicant_filter_params
      set_jobs
      @period = params[:by_period].present? ? "#{params[:by_period][:period]}(applicants.created_at)" : "date(applicants.created_at)" 
      @stage = params[:by_stages].present? ? params[:by_stages][:stage] : Applicant.applicant_statuses 
      @job = params[:by_jobs].present? ? params[:by_jobs][:job] : @jobs.published_and_closed_jobs.ids
      @gender = params[:by_gender].present? ? params[:by_gender][:gender] : ['Male','Female']
    end

    end #end helpers module
  end
end


      # rescue_from ActiveRecord::RecordNotFound do |e|
      #   error_response(message: e.message, status: 404)
      # end

      # rescue_from ActiveRecord::RecordInvalid do |e|
      #   error_response(message: e.message, status: 422)
      # end      

      #   Destroy Token User