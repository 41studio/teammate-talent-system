class LandingPageController < ApplicationController
	skip_before_filter :authenticate_user!
	def index
		if user_signed_in?
			redirect_to dashboards_path
		end
		@search = Job.search(params[:q])
		@filtered_jobs = @search.result
	end
end
