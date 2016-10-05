module API
  module V1
		module Helpers
	    def authenticate!
	      error!('Unauthorized. Invalid or expired token.', 401) unless current_user
	    end

	    def current_user
	      token = ApiKey.find_by(access_token: headers['Token'])
	      if token && !token.expired?
	        @current_user = User.find(token.user_id)
	      else
	        false
	      end
	    end

      def applicant_statuses
        ["applied", "phonescreen", "interview", "offer", "hired"]
      end      
		end
	end
end