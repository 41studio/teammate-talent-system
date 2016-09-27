module API
  module V1
		module Helpers
		  def fullname
		    current_user.first_name + " " + current_user.last_name
		  end

		  def warden
		    env['warden']
		  end

		  def authenticated
		    return true if warden.authenticated?
		    params[:access_token] && @user = User.find_by_authentication_token(params[:access_token])
		  end
		  
		  def current_user
		    warden.user || @user
		  end

		  def authenticate!
       	error!('Unauthorized. Invalid or expired token.', 401) unless authenticated
     	end

      def applicant_statuses
        ["applied", "phonescreen", "interview", "offer", "hired"]
      end      
		end
	end
end