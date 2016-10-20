module API
  module V1
    class Users < Grape::API
      version 'v1'
      format :json

      helpers do
        def user_params
          # byebug
          user_param = ActionController::Parameters.new(params).require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password, :avatar)
          if params.user.avatar.present?
            user_param["avatar"] = ActionDispatch::Http::UploadedFile.new(params.user.avatar)
          end
          user_param
        end

        def error_message
          error!({ status: :error, message: current_user.errors.full_messages.first }) if current_user.errors.any?
        end       
      end

      resource :users do
        before do
          unless ["create", "login", "new"].any? { |word| request.path.include?(word) }
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
              user.user_api(user)
            else
              error_msg = 'Invalid Email or password.'
              error!({ 'error_msg' => error_msg }, 401)
            end
          rescue ActiveRecord::RecordNotFound
            error!({status: :not_found}, 404)
          end 
        end

        desc "Logout User", {
          :notes => <<-NOTE
          Destroy Token User
          -------------------
          NOTE
        }
        delete '/logout' do
          if ApiKey.find_by(access_token: headers['Token']).destroy!
            { status: "Log outsuccess" }
          end
        end

        desc "User Registration", {
          :notes => <<-NOTE
          User Registration
          -----------------
          NOTE
        }
        post '/new' do
          begin
            users = User.create(user_params)
            if users.save!
              { status: :success }
            else
              error_message
            end

          rescue ActiveRecord::RecordNotFound
            error!({status: :not_found}, 404)
          end 
        end       
        
        desc "User Profile", {
          :notes => <<-NOTE
          User Profile (show)
          ------------------
          NOTE
        }
        get '/profile' do
          present current_user, with: API::V1::Entities::User, except: [:id, :fullname]
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
          :notes => <<-NOTE
          Update user profile process (put)
          ---------------------------------
          NOTE
        }
        params do
          requires :user, type: Hash do
            requires :first_name                        ,type: String, desc: "User first name"
            requires :last_name                         ,type: String, desc: "User last name"
            requires :email                             ,type: String, desc: "User email"
            optional :password                          ,type: String, desc: "User password 
            (leave blank if you don't want to change it) ", allow_blank: true
            optional :password_confirmation             ,type: String, desc: "User password confirmation", allow_blank: true
            requires :current_password                  ,type: String, desc: "User current password 
            (we need your current password to confirm your changes) "
            optional :avatar                            ,type: File, desc: "User avatar"
          end
        end
        put '/update' do      
          # byebug
          # user = current_user
          if current_user.update_with_password(user_params)
            { status: "Update Success" }
          else
            # error_message
            error!({ status: :error, message: current_user.errors.full_messages.first }) if current_user.errors.any?
          end
        end
      end #end resource
    end
  end
end
