module API
  module V1
    class Users < Grape::API
      version 'v1'
      format :json

      helpers do
        def users_params
          ActionController::Parameters.new(params).require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name)
        end
      end

      resource :users do
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
              error_msg = 'Bad Authentication Parameters'
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
          authenticate!
          ApiKey.find_by(access_token: headers['Token']).destroy!
        end

        desc "User Registration", {
          :notes => <<-NOTE
          User Registration
          -----------------
          NOTE
        }
        post '/new' do
          begin
            users = User.create(users_params)
            if users.save!
              { status: :success }
            else
              error!({ status: :error, message: users.errors.full_messages.first }) if users.errors.any?
            end

          rescue ActiveRecord::RecordNotFound
            error!({status: :not_found}, 404)
          end 
        end       
        
      end #end resource
    end
  end
end
