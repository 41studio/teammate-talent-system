class LandingPageController < ApplicationController
	skip_before_filter :authenticate_user!
	def index
		# @jobs = Job.published_jobs		
    if params[:search]
      @jobs = Job.search(params[:search]).order("created_at DESC")
    else
      @jobs = Job.published_jobs.order('created_at DESC')
    end
	end
end
