class LandingPageController < ApplicationController
	skip_before_filter :authenticate_user!
	def index
		if user_signed_in?
			redirect_to dashboards_path
		end
		params[:q][:status_matches] = "published"
		@search = Job.search(params[:q])
		@jobs = @search.result
	end
end
