class LandingPageController < ApplicationController
	skip_before_filter :authenticate_user!
	def index
		@jobs = Job.published_jobs
	end
end
