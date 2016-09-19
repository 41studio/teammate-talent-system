class LandingPageController < ApplicationController
	skip_before_filter :authenticate_user!
	def index
		@companies = Company.all
	end
end
