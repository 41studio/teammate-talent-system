class LandingPageController < ApplicationController
	skip_before_filter :authenticate_user!
	def index
		if user_signed_in?
			redirect_to dashboards_path
		end
		params[:q][:status_matches] = "published" if params[:q].present?
		@search = Job.search(params[:q])
		@jobs = @search.result.published_jobs.page(params[:page]).per(9)
	end
end
