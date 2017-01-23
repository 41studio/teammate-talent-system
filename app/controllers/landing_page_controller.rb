class LandingPageController < ApplicationController
	skip_before_filter :authenticate_user!
  before_action :user_check
	def index
		@search = Job.search(params[:q])
		@jobs = @search.result.published_jobs.page(params[:page]).per(9)
	end
  
  private
    def user_check
      redirect_to dashboards_path if user_signed_in?
    end
end
