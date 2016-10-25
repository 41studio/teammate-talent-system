module API
  module V1
	module Helpers
    extend Grape::API::Helpers
    
    def authenticate!
      error!('Unauthorized. Invalid or expired token.', 401) unless current_user
    end

    def current_user
      token = ApiKey.find_by(access_token: headers['Token'])
      if token && !token.expired?
        User.find(token.user_id)
      else
        false
      end
    end

		Grape::Entity.format_with :timestamp do |date|
		  date.strftime('%m/%d/%Y - %l:%M %p')
		end

		def record_not_found_message
			error!({status: :not_found}, 404)
		end

    params :pagination do
      optional :pages         ,type: Integer, desc: "Pagination"
    end

    def applicant_valid
      error!("You don't have permission.", 401) unless applicant.job.company.users.include?current_user
    end
    
    def get_token
      {
        desc: "Valdates your identity",
        required: true
      }
    end

      # rescue_from ActiveRecord::RecordNotFound do |e|
      #   error_response(message: e.message, status: 404)
      # end

      # rescue_from ActiveRecord::RecordInvalid do |e|
      #   error_response(message: e.message, status: 422)
      # end      
		end
	end
end


        #   :notes => <<-NOTE
        #   Destroy Token User
        #   -------------------
        #   NOTE
        # }
        # desc "Return super-secret information", {