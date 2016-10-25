module API
  module V1
    class Users < Grape::API
      version 'v1'
      format :json

      helpers do
        params :user_params do
            requires :first_name                        ,type: String, desc: "User first name"
            optional :last_name                         ,type: String, desc: "User last name"
            requires :email                             ,type: String, desc: "User email"
            optional :avatar                            ,type: File, desc: "User avatar"
        end

        def user_params
          # byebug
          user_param = ActionController::Parameters.new(params).require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password, :avatar)
          if params.user.avatar.present?
            user_param["avatar"] = ActionDispatch::Http::UploadedFile.new(params.user.avatar)
          end
          user_param
        end 

        def set_user
          @user = current_user
        end    
      end

      resource :users do
        before do
          unless ["sign_up", "login", "new"].any? { |word| request.path.include?(word) }
            authenticate!
          end
        end

        desc "Login User", {
          :notes => <<-NOTE
          Get User By Login
          -------------------
          NOTE
        }
        params do
          requires :email                         ,type: String, desc: "User email"
          requires :password                      ,type: String, desc: "User password"
        end
        post '/login' do
          begin
            if user = User.authenticate_for_api(params[:email], params[:password])
              # user.user_api(user)
              present user, with: API::V1::Entities::UserEntity, only: [:fullname, :email, :token]
            else
              error_msg = 'Invalid Email or password.'
              error!({ 'error_msg' => error_msg }, 401)
            end
          rescue ActiveRecord::RecordNotFound
            error!({status: :not_found}, 404)
          end 
        end

        desc "Logout User", {
          headers: {
            "token" => {
              desc: "Valdates your identity",
              required: true
            }
          } 
        }        
        delete '/logout' do
          if ApiKey.find_by(access_token: headers['Token']).destroy!
            { status: "Log out success" }
          end
        end

        desc "User Registration", {
          :notes => <<-NOTE
          User Registration
          -----------------
          NOTE
        }
        params do
          requires :user, type: Hash do
            use :user_params
            requires :password                          ,type: String, desc: "User password", allow_blank: false
            requires :password_confirmation             ,type: String, desc: "User password confirmation", allow_blank: false
          end
        end        
        post '/sign_up' do
          begin
            users = User.create(user_params)
            if users.save!
              { status: "A message with a confirmation link has been sent to your email address. Please follow the link to activate your account." }
            else
              error!({ status: :error, message: users.errors.full_messages.first }) if users.errors.any?
            end
          rescue ActiveRecord::RecordNotFound
            record_not_found_message
          end 
        end       
        
        desc "User Profile", {
          headers: {
            "token" => {
              desc: "Valdates your identity",
              required: true
            }
          }         
        }
        get '/profile' do
          present current_user, with: API::V1::Entities::UserEntity, except: [:id, :fullname]
        end

        desc "Forget Password", {
          :notes => <<-NOTE
          Sent reset password instructions
          --------------------------------
          NOTE
        }
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

        desc "Update User", {
          headers: {
            "token" => {
              desc: "Valdates your identity",
              required: true
            }
          } 
        }
        params do
          requires :user, type: Hash do
            use :user_params
            optional :password                          ,type: String, desc: "User password 
            (leave blank if you don't want to change it) ", allow_blank: true
            optional :password_confirmation             ,type: String, desc: "User password confirmation", allow_blank: true
            requires :current_password                  ,type: String, desc: "User current password 
            (we need your current password to confirm your changes) "
          end
        end
        put '/update' do      
          set_user
          if @user.update_with_password(user_params)
            { status: "Update Success" }
          else
            error!({ status: :error, message: @user.errors.full_messages.first }) if @user.errors.any?
          end
        end
      end #end resource
    end
  end
end
