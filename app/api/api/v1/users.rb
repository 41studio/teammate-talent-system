module API
  module V1
    class Users < Grape::API
      version 'v1'
      format :json

      helpers do

      end

      resource :users do
        desc "Login User", {
          :notes => <<-NOTE
          Get User By Login
          -------------------
          NOTE
        }
        params do
          requires :email        ,type: String, desc: "User email"
          requires :password        ,type: String, desc: "User password"
        end

        post '/login' do
          begin
            user = User.authenticate_for_api(params[:email], params[:password])
            if user
              {token: user.token, email: user.email, name: user.fullname}
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
            
        end

      end #end resource
    end
  end
end
