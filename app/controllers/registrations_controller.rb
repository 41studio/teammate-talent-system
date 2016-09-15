class RegistrationsController < Devise::RegistrationsController

  after_action :remove_notice, only: :destroy

  private

  def remove_notice
    flash[:notice] = nil
  end
  
  private

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password)
  end

  protected

  def after_sign_up_path_for(resource)
    new_company_path
  end
end