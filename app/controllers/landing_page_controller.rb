class LandingPageController < ApplicationController
	skip_before_filter :authenticate_user!
	def index
		if user_signed_in?
			redirect_to dashboards_path
		end
		
		if params[:sort] == "new"
		    if params[:keyword].present?
		      @filtered_jobs = Job.search_keyword(params[:keyword]).order("created_at ASC")
		    
		    elsif params[:location].present?
		      @filtered_jobs = Job.search_location(params[:location]).order("created_at ASC")
		    
		    elsif params[:max_salary].present? || params[:min_salary].present?
		      @filtered_jobs = Job.search_salary(params[:max_salary], params[:min_salary]).order("min_salary ASC")
			end

		elsif params[:sort] == "relevant"
		    if params[:keyword].present?
		      @filtered_jobs = Job.search_keyword(params[:keyword])
		    
		    elsif params[:location].present?
		      @filtered_jobs = Job.search_location(params[:location])
		    
		    elsif params[:max_salary].present? || params[:min_salary].present?
		      @filtered_jobs = Job.search_salary(params[:max_salary], params[:min_salary])
			end

		else
			@jobs = Job.published_jobs
		end			
	end
end
