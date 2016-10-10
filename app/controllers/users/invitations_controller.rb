class Users::InvitationsController < Devise::InvitationsController
	before_filter :update_sanitized_params, only: :update
  
  def new
  	super
  end
  
  def create
		super
  end
  
  def edit
		super
  end

  def update
    respond_to do |format|
      format.js do
        invitation_token = Devise.token_generator.digest(resource_class, :invitation_token, update_resource_params[:invitation_token])
        self.resource = resource_class.where(invitation_token: invitation_token).first
        resource.skip_password = true
        resource.update_attributes update_resource_params.except(:invitation_token)
      end
      format.html do
        super
      end
    end
  end

  protected
	  def update_sanitized_params
	    devise_parameter_sanitizer.permit(:accept_invitation, keys: [:first_name, :last_name, :company_id, :password, :password_confirmation, :invitation_token])
	  end
	  # caJ3794ViBGsmgJK6xsa
end