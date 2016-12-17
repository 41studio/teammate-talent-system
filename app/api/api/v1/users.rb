module API
  module V1
    class Users < Grape::API
      version 'v1'
      format :json
      helpers Helpers

      helpers do
        params :user_params do
            requires :first_name                        ,type: String, desc: "User first name"
            optional :last_name                         ,type: String, desc: "User last name"
            requires :email                             ,type: String, desc: "User email"
            optional :avatar                            ,type: File, desc: "User avatar"
        end

        def user_params
          user_param = ActionController::Parameters.new(params).require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password, :avatar)
          if params.user.avatar.present?
            user_param["avatar"] = ActionDispatch::Http::UploadedFile.new(params.user.avatar)
          end
          user_param
        end 

        def set_user
          @user = current_user
        end    

        def error_message
          error!({ status: :error, message: @user.errors.full_messages.first }) if @user.errors.any?
        end       
      end

      resource :users do
        before do
          unless ["sign_up", "login", "new"].any? { |word| request.path.include?(word) }
            authenticate!
            set_user
          end
        end

        desc "User's Login" do
          detail " : user get token"
          named 'users'
          headers firebase_access_token: {
            description: 'Valdates your identity',
            required: true
          }           
        end
        params do
          requires :email                  ,type: String, desc: "User email"
          requires :password               ,type: String, desc: "User password"
        end
        post '/login' do
          begin
            firebase_access_token = headers['Firebase-Access-Token'] if headers['Firebase-Access-Token'].present?
            if user = User.authenticate_for_api(params[:email], params[:password], firebase_access_token)
              present user, with: API::V1::Entities::UserEntity, only: [:fullname, :email, :token]
            else
              error!({ status: :error, message: "Invalid Email or Password" }, 401)
            end
          rescue ActiveRecord::RecordNotFound
            error!({status: :not_found}, 404)
          end 
        end

        desc "User's Logout" do
          detail " : destroy users's token"
          named 'users'
          headers token: {
            description: 'Valdates your identity',
            required: true
          } 
        end
        delete '/logout' do
          if ApiKey.find_by(access_token: headers['Token']).destroy!
            { status: "Log out success" }
          end
        end

        desc "User's Registration" do
          detail ' : create account (create)'
          named 'users'
        end
        params do
          requires :user, type: Hash do
            use :user_params
            requires :password               ,type: String, desc: "User password", allow_blank: false
            requires :password_confirmation  ,type: String, desc: "User password confirmation", allow_blank: false
          end
        end        
        post '/sign_up' do
          begin
            @user = User.create(user_params)
            if @user.save!
              { status: "A message with a confirmation link has been sent to your email address. Please follow the link to activate your account." }
              @user
            else
              error_message
            end
          rescue ActiveRecord::RecordNotFound
            record_not_found_message
          end 
        end       
        
        desc "User's Profile" do
          named 'users'
          headers token: {
            description: 'Valdates your identity',
            required: true
          } 
        end
        get '/profile' do
          present @user, with: API::V1::Entities::UserEntity, except: [:id, :fullname]
        end

        desc "Forget Password" do
          detail ' : sent reset password instructions'
          named 'users'
        end
        params do
          requires :email                         ,type: String, desc: "User email"
        end
        post '/password/new' do
          user = User.find_by_email(params[:email])
          if user.present?
            user.send_reset_password_instructions
            { status: "Reset password instructions has sent to your email" }
          else
            { status: "No such email" }
          end
        end

        desc "Edit User" do
          detail ' : edit user form (edit)'
          named 'users'
          headers token: {
            description: 'Valdates your identity',
            required: true
          } 
        end
        get '/edit' do
          present @user, with: API::V1::Entities::UserEntity, except: [:id, :fullname, :token, :joined_at]
        end

        desc "Update User" do
          detail ' : update process (update)'
          named 'users'
          headers token: {
            description: 'Valdates your identity',
            required: true
          } 
        end
        params do
          optional :user, type: Hash do
            optional :first_name                        ,type: String, desc: "User first name", allow_blank: true
            optional :last_name                         ,type: String, desc: "User last name", allow_blank: true
            optional :email                             ,type: String, desc: "User email"
            optional :avatar                            ,type: File, desc: "User avatar", allow_blank: true
            optional :password                          ,type: String, desc: "User password 
            (leave blank if you don't want to change it) ", allow_blank: true
            optional :password_confirmation             ,type: String, desc: "User password confirmation", allow_blank: true
            requires :current_password                  ,type: String, desc: "User current password 
            (we need your current password to confirm your changes) "
          end
        end
        put '/update' do
          if @user.update_with_password(user_params)
            { status: "User Updates" }
            @user
          else
            error_message
          end
        end
      end #end resource
    end
  end
end
