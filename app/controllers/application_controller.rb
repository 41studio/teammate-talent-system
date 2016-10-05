class ApplicationController < ActionController::Base
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

	acts_as_token_authentication_handler_for User, fallback_to_devise: false
	before_filter :authenticate_user!

  def previous_url
    session[:my_previous_url] = URI(request.referer || '').path
  end

  def after_sign_in_path_for(resource)
  	sign_in_url = new_user_session_url
    if request.referer == sign_in_url
      dashboards_path
    else
      stored_location_for(resource) || request.referer || root_path
    end
  end

end